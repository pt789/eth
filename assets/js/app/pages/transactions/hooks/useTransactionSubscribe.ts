import { useEffect, useRef } from "react";
import * as withAbsintheSocket from "@absinthe/socket";
import { useWSContext } from "../../../state/ws-socket";
import { RootSubscriptionType, TransactionUpdatedDocument } from "../../../api";

type Result = { data: RootSubscriptionType };

export const useTransactionSubscribe = (onResult: (data: Result) => void) => {
  const absintheSocket = useWSContext();

  const onResultRef = useRef(onResult);
  onResultRef.current = onResult;

  useEffect(() => {
    const notifier = withAbsintheSocket.send(absintheSocket, {
      operation: TransactionUpdatedDocument,
    });

    const observer = {
      onAbort: () => console.log("abort"),
      onError: () => console.log("error"),
      onStart: () => console.log("open"),
      onResult: (result: Result) => {
        console.log("onResult", result);
        onResultRef.current(result);
      },
    };

    withAbsintheSocket.observe(absintheSocket, notifier, observer);

    return () => {
      withAbsintheSocket.unobserve(absintheSocket, notifier, observer);
    };
  }, []);
};
