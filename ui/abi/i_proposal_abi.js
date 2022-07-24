iProposalAbi = [
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_title",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_descriptionIpfsHash",
				"type": "string"
			}
		],
		"name": "addSection",
		"outputs": [
			{
				"internalType": "address",
				"name": "_sectionAddress",
				"type": "address"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getBackgroundDataLink",
		"outputs": [
			{
				"internalType": "string",
				"name": "_link",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getCurrencyAddress",
		"outputs": [
			{
				"internalType": "address",
				"name": "_currencyAddress",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getOwner",
		"outputs": [
			{
				"internalType": "address",
				"name": "_owner",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_propertyName",
				"type": "string"
			}
		],
		"name": "getPropertyIPFS",
		"outputs": [
			{
				"internalType": "string",
				"name": "_ipfsHash",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_propertyName",
				"type": "string"
			}
		],
		"name": "getPropertyUINT",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_propertyValue",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getProposalResult",
		"outputs": [
			{
				"internalType": "string",
				"name": "_result",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getProposalStatus",
		"outputs": [
			{
				"internalType": "string",
				"name": "_status",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getSections",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "_sections",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getTargetSubmissionDate",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_date",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getTitle",
		"outputs": [
			{
				"internalType": "string",
				"name": "_title",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]