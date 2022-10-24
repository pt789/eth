import { config } from "../../../config";

export function fetcher<TData, TVariables>(
  query: string,
  variables?: TVariables
) {
  return async (): Promise<TData> => {
    const res = await fetch(config.apiUrl, {
      method: "POST",
      ...{
        headers: {
          "Content-Type": "application/json",
          Accept: "application/json",
        },
      },
      body: JSON.stringify({ query, variables }),
    });

    const json = await res.json();

    if (json.errors) {
      const { message } = json.errors[0];

      throw new Error(message);
    }

    return json.data;
  };
}
