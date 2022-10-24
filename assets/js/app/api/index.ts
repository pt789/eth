import { useQuery, useInfiniteQuery, useMutation, UseQueryOptions, UseInfiniteQueryOptions, UseMutationOptions } from '@tanstack/react-query';
import { fetcher } from './fetcher';
export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: string;
  String: string;
  Boolean: boolean;
  Int: number;
  Float: number;
  NaiveDateTime: any;
};

export type PageInfo = {
  __typename?: 'PageInfo';
  /** When paginating forwards, the cursor to continue. */
  endCursor?: Maybe<Scalars['String']>;
  /** When paginating forwards, are there more items? */
  hasNextPage: Scalars['Boolean'];
  /** When paginating backwards, are there more items? */
  hasPreviousPage: Scalars['Boolean'];
  /** When paginating backwards, the cursor to continue. */
  startCursor?: Maybe<Scalars['String']>;
};

export type RootMutationType = {
  __typename?: 'RootMutationType';
  /** Add transaction */
  addTransaction: Transaction;
};


export type RootMutationTypeAddTransactionArgs = {
  txHash: Scalars['String'];
};

export type RootQueryType = {
  __typename?: 'RootQueryType';
  /** Get all transactions */
  transactions: TransactionConnection;
};


export type RootQueryTypeTransactionsArgs = {
  after?: InputMaybe<Scalars['String']>;
  before?: InputMaybe<Scalars['String']>;
  first?: InputMaybe<Scalars['Int']>;
  last?: InputMaybe<Scalars['Int']>;
};

export type RootSubscriptionType = {
  __typename?: 'RootSubscriptionType';
  transactionUpdated: Transaction;
};

export type Transaction = {
  __typename?: 'Transaction';
  completed: Scalars['Boolean'];
  insertedAt: Scalars['NaiveDateTime'];
  txHash: Scalars['String'];
  updatedAt: Scalars['NaiveDateTime'];
};

export type TransactionConnection = {
  __typename?: 'TransactionConnection';
  currentOffset: Scalars['Int'];
  edges: Array<TransactionEdge>;
  pageInfo: PageInfo;
  totalCount: Scalars['Int'];
};

export type TransactionEdge = {
  __typename?: 'TransactionEdge';
  cursor?: Maybe<Scalars['String']>;
  node: Transaction;
};

export type TransactionFragment = { __typename?: 'Transaction', txHash: string, completed: boolean, insertedAt: any, updatedAt: any };

export type TransactionsQueryVariables = Exact<{
  first?: InputMaybe<Scalars['Int']>;
  after?: InputMaybe<Scalars['String']>;
  last?: InputMaybe<Scalars['Int']>;
  before?: InputMaybe<Scalars['String']>;
}>;


export type TransactionsQuery = { __typename?: 'RootQueryType', transactions: { __typename?: 'TransactionConnection', totalCount: number, currentOffset: number, pageInfo: { __typename?: 'PageInfo', hasPreviousPage: boolean, hasNextPage: boolean, endCursor?: string | null, startCursor?: string | null }, edges: Array<{ __typename?: 'TransactionEdge', node: { __typename?: 'Transaction', txHash: string, completed: boolean, insertedAt: any, updatedAt: any } }> } };

export type AddTransactionsMutationVariables = Exact<{
  txHash: Scalars['String'];
}>;


export type AddTransactionsMutation = { __typename?: 'RootMutationType', addTransaction: { __typename?: 'Transaction', txHash: string, completed: boolean, insertedAt: any, updatedAt: any } };

export type TransactionUpdatedSubscriptionVariables = Exact<{ [key: string]: never; }>;


export type TransactionUpdatedSubscription = { __typename?: 'RootSubscriptionType', transactionUpdated: { __typename?: 'Transaction', txHash: string, completed: boolean, insertedAt: any, updatedAt: any } };

export const TransactionFragmentDoc = `
    fragment Transaction on Transaction {
  txHash
  completed
  insertedAt
  updatedAt
}
    `;
export const TransactionsDocument = `
    query Transactions($first: Int, $after: String, $last: Int, $before: String) {
  transactions(first: $first, after: $after, last: $last, before: $before) {
    totalCount
    currentOffset
    pageInfo {
      hasPreviousPage
      hasNextPage
      endCursor
      startCursor
    }
    edges {
      node {
        ...Transaction
      }
    }
  }
}
    ${TransactionFragmentDoc}`;
export const useTransactionsQuery = <
      TData = TransactionsQuery,
      TError = unknown
    >(
      variables?: TransactionsQueryVariables,
      options?: UseQueryOptions<TransactionsQuery, TError, TData>
    ) =>
    useQuery<TransactionsQuery, TError, TData>(
      variables === undefined ? ['Transactions'] : ['Transactions', variables],
      fetcher<TransactionsQuery, TransactionsQueryVariables>(TransactionsDocument, variables),
      options
    );

useTransactionsQuery.getKey = (variables?: TransactionsQueryVariables) => variables === undefined ? ['Transactions'] : ['Transactions', variables];
;

export const useInfiniteTransactionsQuery = <
      TData = TransactionsQuery,
      TError = unknown
    >(
      pageParamKey: keyof TransactionsQueryVariables,
      variables?: TransactionsQueryVariables,
      options?: UseInfiniteQueryOptions<TransactionsQuery, TError, TData>
    ) =>{
    
    return useInfiniteQuery<TransactionsQuery, TError, TData>(
      variables === undefined ? ['Transactions.infinite'] : ['Transactions.infinite', variables],
      (metaData) => fetcher<TransactionsQuery, TransactionsQueryVariables>(TransactionsDocument, {...variables, [pageParamKey]: metaData.pageParam })(),
      options
    )};


useInfiniteTransactionsQuery.getKey = (variables?: TransactionsQueryVariables) => variables === undefined ? ['Transactions.infinite'] : ['Transactions.infinite', variables];
;

export const AddTransactionsDocument = `
    mutation AddTransactions($txHash: String!) {
  addTransaction(txHash: $txHash) {
    ...Transaction
  }
}
    ${TransactionFragmentDoc}`;
export const useAddTransactionsMutation = <
      TError = unknown,
      TContext = unknown
    >(options?: UseMutationOptions<AddTransactionsMutation, TError, AddTransactionsMutationVariables, TContext>) =>
    useMutation<AddTransactionsMutation, TError, AddTransactionsMutationVariables, TContext>(
      ['AddTransactions'],
      (variables?: AddTransactionsMutationVariables) => fetcher<AddTransactionsMutation, AddTransactionsMutationVariables>(AddTransactionsDocument, variables)(),
      options
    );
export const TransactionUpdatedDocument = `
    subscription TransactionUpdated {
  transactionUpdated {
    ...Transaction
  }
}
    ${TransactionFragmentDoc}`;