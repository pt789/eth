import React, { ComponentProps, FC, useState } from "react";
import { config } from "../../../../config";
import {
  Transaction,
  useAddTransactionsMutation,
  useInfiniteTransactionsQuery,
} from "../../api";
import { useToastContext } from "../../state/toast-context";
import { AddTransaction } from "./components/add-transaction";
import { TransactionsTable } from "./components/table";
import { useUpdateTransactionCacheOnSub } from "./hooks/useUpdateTransactionCacheOnSub";

const variables = {
  first: config.itemsPerPage,
  after: null,
};

export const Transactions: FC = () => {
  const { showToast } = useToastContext();

  const [currentPage, setCurrentPage] = useState(0);

  const transactionsQuery = useInfiniteTransactionsQuery("after", variables, {
    getNextPageParam: (lastPage) =>
      lastPage.transactions.pageInfo.hasNextPage
        ? lastPage.transactions.pageInfo.endCursor
        : undefined,
  });

  useUpdateTransactionCacheOnSub(variables);

  const addTransaction = useAddTransactionsMutation({
    onError: (error) => {
      if (error instanceof Error) {
        showToast({
          toast: {
            id: error.message,
            description: error.message,
            title: "Error",
          },
        });
      } else {
        showToast({ genericError: true });
      }
    },
  });

  const transactions =
    transactionsQuery.isFetchingNextPage &&
    transactionsQuery.data?.pages[currentPage - 1].transactions
      ? transactionsQuery.data?.pages[currentPage - 1]?.transactions
      : transactionsQuery.data?.pages[currentPage]?.transactions;

  const openTxDetails: ComponentProps<
    typeof TransactionsTable
  >["openTxDetails"] = (txHash: Transaction["txHash"]) => {
    window.open(`https://etherscan.io/tx/${txHash}`);
  };

  const onSubmit: ComponentProps<typeof AddTransaction>["onSubmit"] = async (
    txHash
  ) => {
    try {
      await addTransaction.mutateAsync({ txHash });
      transactionsQuery.refetch();
    } catch (error) {
      console.log(error);
    }
  };

  const onNextPageChange = () => {
    if (!transactions?.pageInfo.hasNextPage) return;

    transactionsQuery.fetchNextPage();
    setCurrentPage((prev) => prev + 1);
  };

  const onPrevPageChange = () => {
    if (!transactions?.pageInfo.hasPreviousPage) return;

    setCurrentPage((prev) => Math.max(prev - 1, 0));
  };

  return (
    <>
      <AddTransaction
        onSubmit={onSubmit}
        disabled={addTransaction.isLoading || transactionsQuery.isLoading}
      />
      <TransactionsTable
        isLoading={
          transactionsQuery.isLoading || transactionsQuery.isFetchingNextPage
        }
        transactions={transactions?.edges}
        openTxDetails={openTxDetails}
        {...(transactions && {
          pagination: {
            currentOffset: transactions.currentOffset,
            hasNextPage: transactions.pageInfo.hasNextPage,
            hasPreviousPage: transactions.pageInfo.hasPreviousPage,
            totalCount: transactions.totalCount,
            itemsPerPage: config.itemsPerPage,
            onNextPageChange,
            onPrevPageChange,
          },
        })}
      />
    </>
  );
};
