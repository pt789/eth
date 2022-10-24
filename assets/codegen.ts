import type { CodegenConfig } from "@graphql-codegen/cli";
import { config } from "./config";

const codegenConfig: CodegenConfig = {
  overwrite: true,
  schema: config.apiUrl,
  documents: "js/**/*.graphql",
  generates: {
    "js/app/api/index.ts": {
      plugins: [
        "typescript",
        "typescript-operations",
        "typescript-react-query",
      ],
      config: {
        fetcher: "./fetcher#fetcher",
        addInfiniteQuery: true,
        exposeQueryKeys: true,
      },
    },
  },
};

export default codegenConfig;
