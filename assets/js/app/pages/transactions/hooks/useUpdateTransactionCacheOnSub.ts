import { InfiniteData, useQueryClient } from "@tanstack/react-query";
import { TransactionsQuery, useInfiniteTransactionsQuery } from "../../../api";
import { useTransactionSubscribe } from "./useTransactionSubscribe";

export const useUpdateTransactionCacheOnSub = (
  variables: NonNullable<
    Parameters<typeof useInfiniteTransactionsQuery.getKey>[0]
  >
) => {
  const queryClient = useQueryClient();

  useTransactionSubscribe((result) => {
    queryClient.setQueryData<InfiniteData<TransactionsQuery> | undefined>(
      useInfiniteTransactionsQuery.getKey(variables),
      (data) => {
        if (!data) return data;

        return {
          ...data,
          pages: data.pages.map((page) => ({
            ...page,
            transactions: {
              ...page.transactions,
              edges: page.transactions.edges.map((edge) => {
                return edge.node.txHash ===
                  result.data.transactionUpdated.txHash
                  ? { ...edge, node: result.data.transactionUpdated }
                  : edge;
              }),
            },
          })),
        };
      }
    );
  });
};
