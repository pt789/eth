import React, { FC } from "react";
import { TransactionConnection } from "../../../api";

export type PaginationProps = TransactionConnection["pageInfo"] & {
  totalCount: TransactionConnection["totalCount"];
  currentOffset: TransactionConnection["currentOffset"];
  itemsPerPage: number;
  onNextPageChange: () => void;
  onPrevPageChange: () => void;
};

export const Pagination: FC<PaginationProps> = ({
  currentOffset,
  hasNextPage,
  hasPreviousPage,
  itemsPerPage,
  onNextPageChange,
  onPrevPageChange,
  totalCount,
}) => {
  return (
    <div className="styled-table__pagination-container">
      <button disabled={!hasPreviousPage} onClick={onPrevPageChange}>
        Previous
      </button>
      <div className="styled-table__pagination-container__page-label">
        <p>
          Page {currentOffset / itemsPerPage + 1} /{" "}
          {Math.ceil(totalCount / itemsPerPage)}
        </p>
      </div>
      <button disabled={!hasNextPage} onClick={onNextPageChange}>
        Next
      </button>
    </div>
  );
};
