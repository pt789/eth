import React, {
  createContext,
  PropsWithChildren,
  useCallback,
  useContext,
  useMemo,
  useState,
} from "react";
import { Toast } from "../components/toast";

export interface TToast {
  id: string;
  title: string;
  description: string;
}

export interface TToastContextValue {
  showToast: (
    val:
      | { toast: TToast; genericError?: never }
      | { toast?: never; genericError: true }
  ) => void;
}

const TOAST_DELETE_TIME_SEC = 1000 * 5;

const getGenericErrorToast = (): TToast => ({
  id: "defaultError",
  description: "Something went wrong",
  title: "Error",
});

const ToastContext = createContext<TToastContextValue | undefined>(undefined);

export const ToastContextProvider = ({ children }: PropsWithChildren) => {
  const [list, setList] = useState(
    new Map<TToast["id"], TToast & { timeoutId: number }>()
  );

  const deleteToast = (id: TToast["id"]) => {
    setList((prevState) => {
      const item = prevState.get(id);

      if (item) {
        clearTimeout(item.timeoutId);
      }

      const newMap = new Map(prevState);

      newMap.delete(id);

      return newMap;
    });
  };

  const showToast: TToastContextValue["showToast"] = useCallback(
    ({ toast, genericError }) => {
      setList((prevState) => {
        const newMap = new Map(prevState);

        const newToast = genericError ? getGenericErrorToast() : toast;

        const timeoutId = setTimeout(() => {
          deleteToast(newToast.id);
        }, TOAST_DELETE_TIME_SEC);

        newMap.set(newToast.id, { ...newToast, timeoutId });

        return newMap;
      });
    },
    []
  );

  const value = useMemo(() => {
    return { showToast };
  }, [showToast]);

  return (
    <ToastContext.Provider value={value}>
      <Toast list={list} deleteToast={deleteToast} />
      {children}
    </ToastContext.Provider>
  );
};

export const useToastContext = () => {
  const value = useContext(ToastContext);

  if (value === undefined) {
    throw new Error("useToastContext must be used within ToastContextProvider");
  }

  return value;
};
