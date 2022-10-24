const AbsintheSocket = require("@absinthe/socket");
import { Socket as PhoenixSocket } from "phoenix";
import { config } from "../../../config";

export const absintheSocket = AbsintheSocket.create(
  new PhoenixSocket(config.wsUrl)
);
