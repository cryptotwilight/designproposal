iDesignProposalAbi = [
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_daoName",
				"type": "string"
			},
			{
				"internalType": "address",
				"name": "_owner",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "_title",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_targetSubmissionDate",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "_backgroundDataLink",
				"type": "string"
			},
			{
				"internalType": "address",
				"name": "_currencyAddress",
				"type": "address"
			},
			{
				"internalType": "string[]",
				"name": "_IPFSpropertyNames",
				"type": "string[]"
			},
			{
				"internalType": "string[]",
				"name": "_IPFSpropertyValues",
				"type": "string[]"
			},
			{
				"internalType": "string[]",
				"name": "_UINTPropertyNames",
				"type": "string[]"
			},
			{
				"internalType": "uint256[]",
				"name": "_uintPropertyValues",
				"type": "uint256[]"
			}
		],
		"name": "createProposal",
		"outputs": [
			{
				"internalType": "address",
				"name": "_proposal",
				"type": "address"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getDaos",
		"outputs": [
			{
				"internalType": "string[]",
				"name": "_daos",
				"type": "string[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_owner",
				"type": "address"
			}
		],
		"name": "getProposalByOwner",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "_proposals",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getProposalFee",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_price",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "_currency",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getProposals",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "_proposals",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_contributor",
				"type": "address"
			}
		],
		"name": "getProposalsByContributor",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "_proposals",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_daoName",
				"type": "string"
			}
		],
		"name": "getProposalsByDAO",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "_daos",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]