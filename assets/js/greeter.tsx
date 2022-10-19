import React, { FC } from "react";

interface GreeterProps {
  name: string;
}

export const Greeter: FC<GreeterProps> = ({ name }) => {
  return (
    <section className="phx-hero">
      <h1>Welcome to {name} with TypeScript and React!</h1>
      <p>Peace-of-mind from prototype to production</p>
    </section>
  );
};
