import React, { FC } from "react";
import { Transaction, TransactionConnection } from "../../../api";
import { formatDate, parseDate } from "../../../utils/date";
import { Pagination, PaginationProps } from "./pagination";

interface TransactionsTableProps {
  transactions?: TransactionConnection["edges"];
  pagination?: PaginationProps;
  openTxDetails: (txHash: Transaction["txHash"]) => void;
  isLoading: boolean;
}

export const TransactionsTable: FC<TransactionsTableProps> = ({
  transactions,
  pagination,
  openTxDetails,
  isLoading,
}) => {
  if (!transactions) return null;

  return (
    <div>
      <h3>Transactions:</h3>

      <table className="styled-table">
        <thead>
          <tr>
            <th>Hash</th>
            <th>Completed</th>
            <th>Updated At</th>
            <th>Inserted At</th>
          </tr>
        </thead>
        <tbody>
          {transactions.map(({ node }) => (
            <tr key={node.txHash}>
              <td onClick={() => openTxDetails(node.txHash)}>
                <a>{node.txHash}</a>
              </td>
              <td>{node.completed ? "\u2705" : "\u23F3"}</td>
              <td>
                {formatDate({
                  date: parseDate({ dateString: node.updatedAt }),
                })}
              </td>
              <td>
                {formatDate({
                  date: parseDate({ dateString: node.insertedAt }),
                })}
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      <div className="styled-table__footer">
        <div>{isLoading && <h3>Loading...</h3>}</div>
        {pagination && <Pagination {...pagination} />}
      </div>
    </div>
  );
};
