import React, { FC } from "react";
import { TToast } from "../state/toast-context";

interface ToastProps {
  list: Map<TToast["id"], TToast>;
  deleteToast: (id: string) => void;
}

export const Toast: FC<ToastProps> = ({ list, deleteToast }) => {
  return (
    <div className="notification-container bottom-right">
      {[...list.values()].map((toast, i) => (
        <div key={i} className="notification toast bottom-right">
          <button onClick={() => deleteToast(toast.id)}>X</button>
          <div>
            <p className="notification-title">{toast.title}</p>
            <p className="notification-message">{toast.description}</p>
          </div>
        </div>
      ))}
    </div>
  );
};
