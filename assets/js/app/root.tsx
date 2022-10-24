import React, { FC } from "react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { Transactions } from "./pages/transactions";
import { ToastContextProvider } from "./state/toast-context";
import { WSSocketContextProvider } from "./state/ws-socket";

const queryClient = new QueryClient();

export const Root: FC = () => {
  return (
    <WSSocketContextProvider>
      <QueryClientProvider client={queryClient}>
        <ToastContextProvider>
          <Transactions />
        </ToastContextProvider>
      </QueryClientProvider>
    </WSSocketContextProvider>
  );
};
