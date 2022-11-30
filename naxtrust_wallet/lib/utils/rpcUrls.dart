import 'package:cryptowallet/screens/private_sale.dart';
import 'package:flutter/material.dart';

bool hasBitcoin = false;
const ethRpcUrl =
    "https://mainnet.infura.io/v3/53163c736f1d4ba78f0a39ffda8d87b4";
const bscRpcUrl = "https://bsc-dataseed.binance.org/";
const mmenomicToPrivateKeyUrl =
    "http://137.184.44.152:88/create_wallet?memornic_phrase=";
const bscChainId = 56;
const coinbaseApiKey = '76668e58-4186-46a5-8478-5b16cd96d3c6';
const email = 'info@naxtrust.com';

const convertionRate = 0.03;
const ethChainId = 1;
const buyCryptoLink = 'https://www.moonpay.com';
const bnbScanDomain = 'https://bscscan.com';
const bnbScanUrl = '$bnbScanDomain/address/';
const etherScanDomain = 'https://etherscan.io';
const etherScanUrl = '$etherScanDomain/address/';
const bitCoinScanUrl = 'https://www.blockchain.com/btc/address/';
const smartChain = 'Smart Chain';
const ethereum = 'Ethereum';
const cryptoNetworks = <String>[smartChain, ethereum];
const followTwitterAccount = 'http://twitter.com';
const retweetPost = 'http://twitter.com';
const joinDiscord = 'https://discord.com/';
const joinTelegram = 'http://telegram.org';
const private_saleAddr = '0x0000000000000000000000000000000000000000';
const grey = Colors.grey;

const cryptoNetworksExplorerDomain = {
  smartChain: bnbScanDomain,
  ethereum: etherScanDomain
};

/** custom name and address for app token */
const walletAbbr = 'NTC';
const walletName = 'NaxTrust';
const tokenContractAddress = '0x2dab2678840511100ec512b1c9cdbd061055ecc8';
/** end of custom name and address for app token */

const erc20Abi = '''[
    {
        "constant": true,
        "inputs": [],
        "name": "name",
        "outputs": [
            {
                "name": "",
                "type": "string"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_spender",
                "type": "address"
            },
            {
                "name": "_value",
                "type": "uint256"
            }
        ],
        "name": "approve",
        "outputs": [
            {
                "name": "",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "totalSupply",
        "outputs": [
            {
                "name": "",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
      "constant": false,
      "inputs": [{ "name": "_refer", "type": "address" }],
      "name": "tokenSale",
      "outputs": [{ "name": "success", "type": "bool" }],
      "payable": true,
      "stateMutability": "payable",
      "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_from",
                "type": "address"
            },
            {
                "name": "_to",
                "type": "address"
            },
            {
                "name": "_value",
                "type": "uint256"
            }
        ],
        "name": "transferFrom",
        "outputs": [
            {
                "name": "",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "decimals",
        "outputs": [
            {
                "name": "",
                "type": "uint8"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [
            {
                "name": "_owner",
                "type": "address"
            }
        ],
        "name": "balanceOf",
        "outputs": [
            {
                "name": "balance",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "symbol",
        "outputs": [
            {
                "name": "",
                "type": "string"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_to",
                "type": "address"
            },
            {
                "name": "_value",
                "type": "uint256"
            }
        ],
        "name": "transfer",
        "outputs": [
            {
                "name": "",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [
            {
                "name": "_owner",
                "type": "address"
            },
            {
                "name": "_spender",
                "type": "address"
            }
        ],
        "name": "allowance",
        "outputs": [
            {
                "name": "",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "payable": true,
        "stateMutability": "payable",
        "type": "fallback"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "name": "owner",
                "type": "address"
            },
            {
                "indexed": true,
                "name": "spender",
                "type": "address"
            },
            {
                "indexed": false,
                "name": "value",
                "type": "uint256"
            }
        ],
        "name": "Approval",
        "type": "event"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "name": "from",
                "type": "address"
            },
            {
                "indexed": true,
                "name": "to",
                "type": "address"
            },
            {
                "indexed": false,
                "name": "value",
                "type": "uint256"
            }
        ],
        "name": "Transfer",
        "type": "event"
    }
]''';
