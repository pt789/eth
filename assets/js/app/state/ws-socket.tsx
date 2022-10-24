import React, { createContext, PropsWithChildren, useContext } from "react";
import { absintheSocket } from "../api/ws";

const WSSocketContext = createContext<any | undefined>(undefined);

export const WSSocketContextProvider = ({ children }: PropsWithChildren) => {
  return (
    <WSSocketContext.Provider value={absintheSocket}>
      {children}
    </WSSocketContext.Provider>
  );
};

export const useWSContext = () => {
  const value = useContext(WSSocketContext);

  if (value === undefined) {
    throw new Error("useWSContext must be used within WSSocketContextProvider");
  }

  return value;
};
