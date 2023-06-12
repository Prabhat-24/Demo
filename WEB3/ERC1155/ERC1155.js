let web3;
let aAccount = "";
let oContract;
let accounts;
let chainId;
let sepoliaChainId = 11155111;
let sContractAddress = "0xf0AB59555094a45f4fbF97987E4A34dabA8FF480";
let contractAbi = [
  {
    inputs: [
      {
        internalType: "string",
        name: "uri",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "operator",
        type: "address",
      },
      {
        indexed: false,
        internalType: "bool",
        name: "approved",
        type: "bool",
      },
    ],
    name: "ApprovalForAll",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "operator",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256[]",
        name: "ids",
        type: "uint256[]",
      },
      {
        indexed: false,
        internalType: "uint256[]",
        name: "values",
        type: "uint256[]",
      },
    ],
    name: "TransferBatch",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "operator",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "value",
        type: "uint256",
      },
    ],
    name: "TransferSingle",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "string",
        name: "value",
        type: "string",
      },
      {
        indexed: true,
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
    ],
    name: "URI",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
    ],
    name: "balanceOf",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address[]",
        name: "accounts",
        type: "address[]",
      },
      {
        internalType: "uint256[]",
        name: "ids",
        type: "uint256[]",
      },
    ],
    name: "balanceOfBatch",
    outputs: [
      {
        internalType: "uint256[]",
        name: "",
        type: "uint256[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "numberOfTokens",
        type: "uint256",
      },
    ],
    name: "burn",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256[]",
        name: "tokenIds",
        type: "uint256[]",
      },
      {
        internalType: "uint256[]",
        name: "numberOfTokens",
        type: "uint256[]",
      },
    ],
    name: "burnBatch",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        internalType: "address",
        name: "operator",
        type: "address",
      },
    ],
    name: "isApprovedForAll",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "numberOfTokens",
        type: "uint256",
      },
    ],
    name: "mint",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256[]",
        name: "tokenIds",
        type: "uint256[]",
      },
      {
        internalType: "uint256[]",
        name: "numberOfTokens",
        type: "uint256[]",
      },
    ],
    name: "mintBatch",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256[]",
        name: "ids",
        type: "uint256[]",
      },
      {
        internalType: "uint256[]",
        name: "amounts",
        type: "uint256[]",
      },
      {
        internalType: "bytes",
        name: "data",
        type: "bytes",
      },
    ],
    name: "safeBatchTransferFrom",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
      {
        internalType: "bytes",
        name: "data",
        type: "bytes",
      },
    ],
    name: "safeTransferFrom",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "operator",
        type: "address",
      },
      {
        internalType: "bool",
        name: "approved",
        type: "bool",
      },
    ],
    name: "setApprovalForAll",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes4",
        name: "interfaceId",
        type: "bytes4",
      },
    ],
    name: "supportsInterface",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "uri",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];
async function connectMetamask() {
  if (window.ethereum) {
    try {
      web3 = new Web3(window.ethereum);
      chainId = await web3.eth.getChainId();
      oContract = new web3.eth.Contract(contractAbi, sContractAddress);

      accounts = await window.ethereum.request({
        method: "eth_requestAccounts",
      });
      if (chainId !== sepoliaChainId) {
        let newChainId = "0x" + sepoliaChainId.toString(16);

        await window.ethereum.request({
          method: "wallet_switchEthereumChain",
          params: [{ chainId: newChainId }],
        });
      } else {
        $("#network").text("ChainId: " + chainId);
      }

      if (accounts.length > 0) {
        toastr.success("Wallet connected successfully");

        $("#account").text("Address:" + accounts[0]);
        aAccount = accounts[0];

        $("#connectBtn").hide();
        $("#disConnectBtn").show();
      }

      web3.eth.currentProvider.on("accountsChanged", function (accounts) {
        if (accounts.length === 0) {
          location.reload();
        } else {
          aAccount = accounts[0];
          $("#account").text("Address: " + accounts[0]);
        }
      });
      web3.eth.currentProvider.on("chainChanged", async function (chainId) {
        chainId = await web3.eth.getChainId();
        if (chainId !== sepoliaChainId) {
          let newChainId = "0x" + sepoliaChainId.toString(16);
          await window.ethereum.request({
            method: "wallet_switchEthereumChain",
            params: [{ chainId: newChainId }],
          });
        } else {
          $("#network").text("ChainId: " + chainId);
        }
      });
    } catch (error) {
      toastr.error("Error connecting to MetaMask:", error);
    }
  } else {
    window.location.href = "https://metamask.io/";
  }
}

function disConnectMetamask() {
  $("#connectBtn").show();
  $("#disConnectBtn").hide();
  location.reload();
}

async function mint() {
  try {
    if (!aAccount) await connectMetamask();
    const tokenId = $("#mintId").val();
    const mintQuantity = $("#mintAmount").val();

    if (!tokenId || isNaN(tokenId)) {
      toastr.warning("A valid tokenId is required");
      return;
    }
    if (!mintQuantity || isNaN(mintQuantity)) {
      toastr.warning("A valid amount is required");
      return;
    }
    $("#mintBtn").prop("disabled", true);
    const estimateGas = await oContract.methods
      .mint(tokenId, mintQuantity)
      .estimateGas({ from: aAccount });

    console.log(estimateGas);

    await oContract.methods
      .mint(tokenId, mintQuantity)
      .send({ from: aAccount, gas: estimateGas });
    $("#mintBtn").prop("disabled", false);
  } catch (error) {
    if (error.message.includes("User denied")) {
      toastr.warning("You rejected the transaction on Metamask!");
    } else {
      toastr.error(error.message);
    }
    $("#mintBtn").prop("disabled", false);
  }
}

async function burn() {
  try {
    if (!aAccount) await connectMetamask();
    const tokenId = $("#burnId").val();
    const burnQuantity = $("#burnAmount").val();

    if (!tokenId || isNaN(tokenId)) {
      toastr.warning("A valid tokenId is required");
      return;
    }

    if (!burnQuantity || isNaN(burnQuantity)) {
      toastr.warning("A valid amount is required");
      return;
    }
    $("#BurnBtn").prop("disabled", true);

    const estimateGas = await oContract.methods
      .burn(tokenId, burnQuantity)
      .estimateGas({ from: aAccount });

    console.log(estimateGas);

    await oContract.methods
      .burn(tokenId, burnQuantity)
      .send({ from: aAccount, gas: estimateGas });

    $("#mintBtn").prop("disabled", false);
  } catch (error) {
    if (error.message.includes("User denied")) {
      toastr.warning("You rejected the transaction on Metamask!");
    } else {
      toastr.error(error.message);
    }
    $("#BurnBtn").prop("disabled", false);
  }
}

async function balanceOf() {
  try {
    if (!aAccount) await connectMetamask();
    const tokenId = $("#tokenId").val();
    const address = $("#address").val();

    if (!tokenId || isNaN(tokenId)) {
      toastr.warning("A valid tokenId is required");
      return;
    }

    if (!web3.utils.isAddress(address)) {
      toastr.warning("A valid address is required");
      return;
    }

    const balance = await oContract.methods.balanceOf(address, tokenId).call();
    toastr.success("Balance of " + address + ": " + balance);
  } catch (error) {
    toastr.error(error.message);
  }
}

async function isApprovedForAll() {
  try {
    if (!aAccount) await connectMetamask();
    const owner = $("#addrOwner").val();
    const operator = $("#addrOperator").val();
    if (!web3.utils.isAddress(owner) || !web3.utils.isAddress(operator)) {
      toastr.warning("A valid address is required");
      return;
    }
    const isApproved = await oContract.methods
      .isApprovedForAll(owner, operator)
      .call();
    toastr.success(operator + " isApproved: " + isApproved);
  } catch (error) {
    toastr.error(error.message);
  }
}

async function setApprovalForAll() {
  try {
    if (!aAccount) await connectMetamask();
    const isApprovedForAll =
      $("input[name='IsApprovedForAll']:checked").val() === "true"
        ? true
        : false;
    const operator = $("#operatorAddr").val();

    if (!web3.utils.isAddress(operator)) {
      toastr.warning("A valid address is required");
      return;
    }

    if (aAccount === operator) {
      toastr.warning("owner can't be operator");
      return;
    }

    if (!typeof isApprovedForAll === "boolean") {
      toastr.warning("Please select true or false");
      return;
    }

    if (!typeof isApprovedForAll === "boolean") {
      toastr.warning("please select true or false");
      return;
    }
    $("#setApprovalBtn").prop("disabled", true);

    const estimateGas = await oContract.methods
      .setApprovalForAll(operator, isApprovedForAll)
      .estimateGas({ from: aAccount });

    console.log(estimateGas);

    await oContract.methods
      .setApprovalForAll(operator, isApprovedForAll)
      .send({ from: aAccount, gas: estimateGas });

    $("#setApprovalBtn").prop("disabled", false);
  } catch (error) {
    if (error.message.includes("User denied")) {
      toastr.warning("You rejected the transaction on Metamask!");
    } else {
      toastr.error(error.message);
    }
    $("#setApprovalBtn").prop("disabled", false);
  }
}

async function safeTransferFrom() {
  try {
    if (!aAccount) await connectMetamask();
    const addressFrom = $("#safeTransferFrom").val();
    const addressTo = $("#safeTransferTo").val();
    const tokenId = $("#safeTransferTokenId").val();
    const amount = $("#safeTransferAmount").val();
    if (
      !web3.utils.isAddress(addressFrom) ||
      !web3.utils.isAddress(addressTo)
    ) {
      toastr.warning("A valid address is required");
      return;
    }
    if (addressFrom === addressTo) {
      toastr.warning("from address and to address are equal");
      return;
    }
    if (!tokenId || isNaN(tokenId)) {
      toastr.warning("A valid tokenId is required");
      return;
    }
    if (!amount || isNaN(amount)) {
      toastr.warning("A valid amount is required");
      return;
    }
    $("#safeTransferFromBtn").prop("disabled", true);

    const estimateGas = await oContract.methods
      .safeTransferFrom(addressFrom, addressTo, tokenId, amount, "0x0000")
      .estimateGas({ from: aAccount });

    console.log(estimateGas);

    await oContract.methods
      .safeTransferFrom(addressFrom, addressTo, tokenId, amount, "0x0000")
      .send({ from: aAccount, gas: estimateGas });

    $("#safeTransferFromBtn").prop("disabled", false);
  } catch (error) {
    if (error.message.includes("User denied")) {
      toastr.warning("You rejected the transaction on Metamask!");
    } else {
      toastr.error(error.message);
    }
    $("#safeTransferFromBtn").prop("disabled", false);
  }
}

async function mintBatch() {
  try {
    if (!aAccount) await connectMetamask();
    const ids = $("#mintIds").val();
    const amounts = $("#mintAmounts").val();

    const aIds = ids.split(",").map(Number);
    const aAmounts = amounts.split(",").map(Number);

    for (let i = 0; i < aIds.length; i++) {
      if (!aIds[i] || isNaN(aIds[i])) {
        toastr.warning("valid token Ids required");
        return;
      }
    }
    for (let i = 0; i < aAmounts.length; i++) {
      if (!aAmounts[i] || isNaN(aAmounts[i])) {
        toastr.warning("valid amounts required");
        return;
      }
    }
    $("#mintBatchBtn").prop("disabled", true);

    const estimateGas = await oContract.methods
      .mintBatch(aIds, aAmounts)
      .estimateGas({ from: aAccount });

    console.log(estimateGas);

    await oContract.methods
      .mintBatch(aIds, aAmounts)
      .send({ from: aAccount, gas: estimateGas });

    $("#mintBatchBtn").prop("disabled", false);
  } catch (error) {
    if (error.message.includes("User denied")) {
      toastr.warning("You rejected the transaction on Metamask!");
    } else {
      toastr.error(error.message);
    }
    $("#mintBatchBtn").prop("disabled", false);
  }
}

async function burnBatch() {
  try {
    if (!aAccount) await connectMetamask();

    const ids = $("#burnIds").val();
    const amounts = $("#burnAmounts").val();

    const aIds = ids.split(",").map(Number);
    const aAmounts = amounts.split(",").map(Number);

    for (let i = 0; i < aIds.length; i++) {
      if (!aIds[i] || isNaN(aIds[i])) {
        toastr.warning("valid token Ids required");
        return;
      }
    }
    for (let i = 0; i < aAmounts.length; i++) {
      if (!aAmounts[i] || isNaN(aAmounts[i])) {
        toastr.warning("valid amounts required");
        return;
      }
    }
    $("#burnBatchBtn").prop("disabled", true);

    const estimateGas = await oContract.methods
      .burnBatch(aIds, aAmounts)
      .estimateGas({ from: aAccount });

    console.log(estimateGas);

    await oContract.methods
      .burnBatch(aIds, aAmounts)
      .send({ from: aAccount, gas: estimateGas });

    $("#burnBatchBtn").prop("disabled", false);
  } catch (error) {
    if (error.message.includes("User denied")) {
      toastr.warning("You rejected the transaction on Metamask!");
    } else {
      toastr.error(error.message);
    }
    $("#burnBatchBtn").prop("disabled", false);
  }
}

async function safeBatchTransferFrom() {
  try {
    if (!aAccount) await connectMetamask();
    const addressFrom = $("#BatchTransferFrom").val();
    const addressTo = $("#BatchTransferTo").val();
    const ids = $("#BatchTransferIds").val();
    const amounts = $("#BatchTransferAmounts").val();
    const aIds = ids.split(",").map(Number);
    const aAmounts = amounts.split(",").map(Number);

    if (
      !web3.utils.isAddress(addressFrom) ||
      !web3.utils.isAddress(addressTo)
    ) {
      toastr.warning("A valid address is required");
      return;
    }
    if (addressFrom === addressTo) {
      toastr.warning("from address and to address are equal");
      return;
    }

    for (let i = 0; i < aIds.length; i++) {
      if (!aIds[i] || isNaN(aIds[i])) {
        toastr.warning("valid token Ids required");
        return;
      }
    }
    for (let i = 0; i < aAmounts.length; i++) {
      if (!aAmounts[i] || isNaN(aAmounts[i])) {
        toastr.warning("valid amounts required");
        return;
      }
    }
    $("#safeBatchTransferFromBtn").prop("disabled", true);

    const estimateGas = await oContract.methods
      .safeBatchTransferFrom(addressFrom, addressTo, aIds, aAmounts, "0x0000")
      .estimateGas({ from: aAccount });

    console.log(estimateGas);

    await oContract.methods
      .safeBatchTransferFrom(addressFrom, addressTo, aIds, aAmounts, "0x0000")
      .send({ from: aAccount, gas: estimateGas });

    $("#safeBatchTransferFromBtn").prop("disabled", false);
  } catch (error) {
    if (error.message.includes("User denied")) {
      toastr.warning("You rejected the transaction on Metamask!");
    } else {
      toastr.error(error);
    }
    $("#safeBatchTransferFromBtn").prop("disabled", false);
  }
}
