iSectionAbi = [
	{
		"inputs": [],
		"name": "getContent",
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
		"inputs": [],
		"name": "getCycleTimeRemaining",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_time",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getOriginator",
		"outputs": [
			{
				"internalType": "address",
				"name": "_author",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getProposal",
		"outputs": [
			{
				"internalType": "address",
				"name": "_proposal",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getSectionId",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_id",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getStatus",
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
	},
	{
		"inputs": [],
		"name": "getVoteResult",
		"outputs": [
			{
				"internalType": "string",
				"name": "_voteResult",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getVotes",
		"outputs": [
			{
				"components": [
					{
						"internalType": "bool",
						"name": "upVote",
						"type": "bool"
					},
					{
						"internalType": "address",
						"name": "voter",
						"type": "address"
					},
					{
						"internalType": "string",
						"name": "commentIpfsHash",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "amountPaid",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "voteTime",
						"type": "uint256"
					}
				],
				"internalType": "struct ISection.Vote[]",
				"name": "_votes",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bool",
				"name": "_upVote",
				"type": "bool"
			},
			{
				"internalType": "string",
				"name": "_ipfsHash",
				"type": "string"
			}
		],
		"name": "vote",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_voted",
				"type": "bool"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "withdrawSection",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_withdrawn",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]