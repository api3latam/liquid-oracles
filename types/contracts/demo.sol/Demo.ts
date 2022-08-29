/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
  BytesLike,
  CallOverrides,
  ContractTransaction,
  Overrides,
  PopulatedTransaction,
  Signer,
  utils,
} from "ethers";
import type { FunctionFragment, Result } from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
  PromiseOrValue,
} from "../../common";

export interface DemoInterface extends utils.Interface {
  functions: {
    "airnodeCallback(bytes32,bytes)": FunctionFragment;
    "airnodeRrp()": FunctionFragment;
    "callTheAirnode(address,bytes32,address,address,bytes)": FunctionFragment;
    "fulfilledData(bytes32)": FunctionFragment;
    "incomingFulfillments(bytes32)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "airnodeCallback"
      | "airnodeRrp"
      | "callTheAirnode"
      | "fulfilledData"
      | "incomingFulfillments"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "airnodeCallback",
    values: [PromiseOrValue<BytesLike>, PromiseOrValue<BytesLike>]
  ): string;
  encodeFunctionData(
    functionFragment: "airnodeRrp",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "callTheAirnode",
    values: [
      PromiseOrValue<string>,
      PromiseOrValue<BytesLike>,
      PromiseOrValue<string>,
      PromiseOrValue<string>,
      PromiseOrValue<BytesLike>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "fulfilledData",
    values: [PromiseOrValue<BytesLike>]
  ): string;
  encodeFunctionData(
    functionFragment: "incomingFulfillments",
    values: [PromiseOrValue<BytesLike>]
  ): string;

  decodeFunctionResult(
    functionFragment: "airnodeCallback",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "airnodeRrp", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "callTheAirnode",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "fulfilledData",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "incomingFulfillments",
    data: BytesLike
  ): Result;

  events: {};
}

export interface Demo extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: DemoInterface;

  queryFilter<TEvent extends TypedEvent>(
    event: TypedEventFilter<TEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TEvent>>;

  listeners<TEvent extends TypedEvent>(
    eventFilter?: TypedEventFilter<TEvent>
  ): Array<TypedListener<TEvent>>;
  listeners(eventName?: string): Array<Listener>;
  removeAllListeners<TEvent extends TypedEvent>(
    eventFilter: TypedEventFilter<TEvent>
  ): this;
  removeAllListeners(eventName?: string): this;
  off: OnEvent<this>;
  on: OnEvent<this>;
  once: OnEvent<this>;
  removeListener: OnEvent<this>;

  functions: {
    airnodeCallback(
      requestId: PromiseOrValue<BytesLike>,
      data: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    airnodeRrp(overrides?: CallOverrides): Promise<[string]>;

    callTheAirnode(
      airnode: PromiseOrValue<string>,
      endpointId: PromiseOrValue<BytesLike>,
      sponsor: PromiseOrValue<string>,
      sponsorWallet: PromiseOrValue<string>,
      parameters: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    fulfilledData(
      arg0: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    incomingFulfillments(
      arg0: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<[boolean]>;
  };

  airnodeCallback(
    requestId: PromiseOrValue<BytesLike>,
    data: PromiseOrValue<BytesLike>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  airnodeRrp(overrides?: CallOverrides): Promise<string>;

  callTheAirnode(
    airnode: PromiseOrValue<string>,
    endpointId: PromiseOrValue<BytesLike>,
    sponsor: PromiseOrValue<string>,
    sponsorWallet: PromiseOrValue<string>,
    parameters: PromiseOrValue<BytesLike>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  fulfilledData(
    arg0: PromiseOrValue<BytesLike>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  incomingFulfillments(
    arg0: PromiseOrValue<BytesLike>,
    overrides?: CallOverrides
  ): Promise<boolean>;

  callStatic: {
    airnodeCallback(
      requestId: PromiseOrValue<BytesLike>,
      data: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<void>;

    airnodeRrp(overrides?: CallOverrides): Promise<string>;

    callTheAirnode(
      airnode: PromiseOrValue<string>,
      endpointId: PromiseOrValue<BytesLike>,
      sponsor: PromiseOrValue<string>,
      sponsorWallet: PromiseOrValue<string>,
      parameters: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<void>;

    fulfilledData(
      arg0: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    incomingFulfillments(
      arg0: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<boolean>;
  };

  filters: {};

  estimateGas: {
    airnodeCallback(
      requestId: PromiseOrValue<BytesLike>,
      data: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    airnodeRrp(overrides?: CallOverrides): Promise<BigNumber>;

    callTheAirnode(
      airnode: PromiseOrValue<string>,
      endpointId: PromiseOrValue<BytesLike>,
      sponsor: PromiseOrValue<string>,
      sponsorWallet: PromiseOrValue<string>,
      parameters: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    fulfilledData(
      arg0: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    incomingFulfillments(
      arg0: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    airnodeCallback(
      requestId: PromiseOrValue<BytesLike>,
      data: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    airnodeRrp(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    callTheAirnode(
      airnode: PromiseOrValue<string>,
      endpointId: PromiseOrValue<BytesLike>,
      sponsor: PromiseOrValue<string>,
      sponsorWallet: PromiseOrValue<string>,
      parameters: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    fulfilledData(
      arg0: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    incomingFulfillments(
      arg0: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;
  };
}