import 'package:flutter/services.dart';
import 'package:textify/utils/constants.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract () async {
  String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = contractAddress1;
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'CrowdFunding'), EthereumAddress.fromHex(contractAddress));
  return contract;
}
Future<String> callFunction(String funcname, List<dynamic> args, Web3Client ethClient, String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(funcname);
  final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
      ),
      chainId: null,
      fetchChainIdFromNetworkId: true);
  return result;
}

Future<List<dynamic>> ask(
    String funcName, List<dynamic> args, Web3Client ethClient) async {
  final contract = await loadContract();
  final ethFunction = contract.function(funcName);
  final result =
  ethClient.call(contract: contract, function: ethFunction, params: args);
  return result;
}

Future<String> registerEvent(String name, Web3Client ethClient) async {
  var response =
  await callFunction('registerEvent', [name], ethClient, owner_private_key);
  print('Event Registered successfully');
  return response;
}

Future<String> setData(int amount, int minAmount, int deadline, Web3Client ethClient) async {
  var response =
  await callFunction('setData', [BigInt.from(amount), BigInt.from(minAmount), BigInt.from(deadline)], ethClient, owner_private_key);
  print('Basic Data set successfully');
  return response;
}

Future<String> donate(Web3Client ethClient) async {
  var response =
  await callFunction('donate', [], ethClient, donar_private_key);
  print('Fund donated successfully');
  return response;
}

Future<String> request_to_spend(int required, String recipient, String desc,Web3Client ethClient) async {
  var response =
  await callFunction('request_to_spend', [BigInt.from(required), EthereumAddress.fromHex(recipient), desc], ethClient, owner_private_key);
  print('Sent pay request successfully');
  return response;
}