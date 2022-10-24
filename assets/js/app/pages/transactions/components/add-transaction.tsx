import React, {
  ChangeEventHandler,
  FC,
  FormEventHandler,
  useState,
} from "react";

interface AddTransactionProps {
  onSubmit: (txHash: string) => void;
  disabled: boolean;
}

export const AddTransaction: FC<AddTransactionProps> = ({
  onSubmit,
  disabled,
}) => {
  const [txHash, setTxHash] = useState("");

  const onInputChange: ChangeEventHandler<HTMLInputElement> = (e) =>
    setTxHash(e.target.value);

  const _onSubmit: FormEventHandler<HTMLFormElement> = (e) => {
    e.preventDefault();
    onSubmit(txHash);
    setTxHash("");
  };

  return (
    <div className="add-transaction">
      <h3>Add Transaction:</h3>

      <form onSubmit={_onSubmit}>
        <label className="add-transaction__label">
          Transaction Hash:
          <input
            className="add-transaction__label__input"
            type="text"
            name="txHash"
            onChange={onInputChange}
            value={txHash}
          />
        </label>
        <input
          className="add-transaction__submit-btn"
          type="submit"
          value="Submit"
          disabled={disabled || !txHash}
        />
      </form>
    </div>
  );
};
