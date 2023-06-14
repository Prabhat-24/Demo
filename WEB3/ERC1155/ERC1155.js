let web3;
let aAccount = "";
let oContract;
let accounts;
let chainId;
const sepoliaChainId = 11155111;
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
    toastr.clear();
    try {
      web3 = new Web3(window.ethereum);

      oContract = new web3.eth.Contract(contractAbi, sContractAddress);

      chainId = await web3.eth.getChainId();
      $("#network").text("ChainId: " + chainId);

      accounts = await window.ethereum.request({
        method: "eth_requestAccounts",
      });

      if (chainId !== sepoliaChainId) {
        let newChainId = web3.utils.toHex(sepoliaChainId);

        await window.ethereum.request({
          method: "wallet_switchEthereumChain",
          params: [{ chainId: newChainId }],
        });

        toastr.success("network switched successfully");
      }

      if (accounts.length) {
        toastr.success("Wallet connected successfully");

        $("#account").text("Address:" + accounts[0]);
        aAccount = accounts[0];

        $("#connectBtn").hide();
        $("#disConnectBtn").show();
      }

      web3.eth.currentProvider.on("accountsChanged", function (accounts) {
        if (!accounts.length) {
          location.reload();
        } else {
          aAccount = accounts[0];
          toastr.success("account changed successfully");
          $("#account").text("Address: " + aAccount);
        }
      });

      web3.eth.currentProvider.on("chainChanged", async function (chainId) {
        chainId = await web3.eth.getChainId();
        $("#network").text("ChainId: " + chainId);
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
    const tokenId = $("#mintId").val();
    const mintQuantity = $("#mintAmount").val();
    toastr.clear();

    if (
      !tokenId ||
      isNaN(tokenId) ||
      tokenId <= 0 ||
      !Number.isInteger(Number(tokenId))
    ) {
      toastr.warning("A valid tokenId is required");
      return;
    }

    if (
      !mintQuantity ||
      isNaN(mintQuantity) ||
      mintQuantity <= 0 ||
      !Number.isInteger(Number(mintQuantity))
    ) {
      toastr.warning("A valid amount is required");
      return;
    }
    if (!aAccount) {
      await connectMetamask();
    } else {
      chainId = await web3.eth.getChainId();
      await checkNetwork(chainId);
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
      let oErrorJSON = JSON.parse(
        error.message.substr(
          error.message.indexOf("{"),
          error.message.lastIndexOf("}")
        )
      );
      const oError = oErrorJSON.originalError.message;
      toastr.error(oError);
    }
    $("#mintBtn").prop("disabled", false);
  }
}

async function burn() {
  try {
    const tokenId = $("#burnId").val();
    const burnQuantity = $("#burnAmount").val();
    toastr.clear();
    if (
      !tokenId ||
      isNaN(tokenId) ||
      tokenId <= 0 ||
      !Number.isInteger(Number(tokenId))
    ) {
      toastr.warning("A valid tokenId is required");
      return;
    }

    if (
      !burnQuantity ||
      isNaN(burnQuantity) ||
      burnQuantity <= 0 ||
      !Number.isInteger(Number(burnQuantity))
    ) {
      toastr.warning("A valid amount is required");
      return;
    }
    if (!aAccount) {
      await connectMetamask();
    } else {
      chainId = await web3.eth.getChainId();
      await checkNetwork(chainId);
    }
    $("#BurnBtn").prop("disabled", true);

    const estimateGas = await oContract.methods
      .burn(tokenId, burnQuantity)
      .estimateGas({ from: aAccount });

    console.log(estimateGas);

    await oContract.methods
      .burn(tokenId, burnQuantity)
      .send({ from: aAccount, gas: estimateGas });

    $("#BurnBtn").prop("disabled", false);
  } catch (error) {
    if (error.message.includes("User denied")) {
      toastr.warning("You rejected the transaction on Metamask!");
    } else {
      let oErrorJSON = JSON.parse(
        error.message.substr(
          error.message.indexOf("{"),
          error.message.lastIndexOf("}")
        )
      );
      const oError = oErrorJSON.originalError.message;
      toastr.error(oError);
    }
    $("#BurnBtn").prop("disabled", false);
  }
}

async function balanceOf() {
  try {
    const tokenId = $("#tokenId").val();
    const address = $("#address").val();
    toastr.clear();
    if (
      !tokenId ||
      isNaN(tokenId) ||
      tokenId <= 0 ||
      !Number.isInteger(Number(tokenId))
    ) {
      toastr.warning("A valid tokenId is required");
      return;
    }

    if (!web3.utils.isAddress(address)) {
      toastr.warning("A valid address is required");
      return;
    }
    if (!aAccount) await connectMetamask();
    const balance = await oContract.methods.balanceOf(address, tokenId).call();
    toastr.success("Balance of " + address + ": " + balance);
  } catch (error) {
    toastr.error(error.message);
  }
}

async function isApprovedForAll() {
  try {
    const owner = $("#addrOwner").val();
    const operator = $("#addrOperator").val();
    toastr.clear();
    if (!web3.utils.isAddress(owner) || !web3.utils.isAddress(operator)) {
      toastr.warning("A valid address is required");
      return;
    }
    if (!aAccount) await connectMetamask();
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
    const isApprovedForAll =
      $("input[name='IsApprovedForAll']:checked").val() === "true"
        ? true
        : false;
    const operator = $("#operatorAddr").val();
    toastr.clear();
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
    if (!aAccount) {
      await connectMetamask();
    } else {
      chainId = await web3.eth.getChainId();
      await checkNetwork(chainId);
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
      let oErrorJSON = JSON.parse(
        error.message.substr(
          error.message.indexOf("{"),
          error.message.lastIndexOf("}")
        )
      );
      const oError = oErrorJSON.originalError.message;
      toastr.error(oError);
    }
    $("#setApprovalBtn").prop("disabled", false);
  }
}

async function safeTransferFrom() {
  try {
    const addressFrom = $("#safeTransferFrom").val();
    const addressTo = $("#safeTransferTo").val();
    const tokenId = $("#safeTransferTokenId").val();
    const amount = $("#safeTransferAmount").val();
    toastr.clear();
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
    if (
      !tokenId ||
      isNaN(tokenId) ||
      tokenId <= 0 ||
      !Number.isInteger(Number(tokenId))
    ) {
      toastr.warning("A valid tokenId is required");
      return;
    }
    if (
      !amount ||
      isNaN(amount) ||
      amount <= 0 ||
      !Number.isInteger(number(amount))
    ) {
      toastr.warning("A valid amount is required");
      return;
    }
    if (!aAccount) {
      await connectMetamask();
    } else {
      chainId = await web3.eth.getChainId();
      await checkNetwork(chainId);
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
      let oErrorJSON = JSON.parse(
        error.message.substr(
          error.message.indexOf("{"),
          error.message.lastIndexOf("}")
        )
      );
      const oError = oErrorJSON.originalError.message;
      toastr.error(oError);
    }
    $("#safeTransferFromBtn").prop("disabled", false);
  }
}

async function mintBatch() {
  try {
    const ids = $("#mintIds").val();
    const amounts = $("#mintAmounts").val();

    const aIds = ids.split(",").map(Number);
    const aAmounts = amounts.split(",").map(Number);
    toastr.clear();
    for (let i = 0; i < aIds.length; i++) {
      if (
        !aIds[i] ||
        isNaN(aIds[i]) ||
        aIds[i] <= 0 ||
        !Number.isInteger(Number(aIds[i]))
      ) {
        toastr.warning("valid token Ids required");
        return;
      }
    }

    for (let i = 0; i < aAmounts.length; i++) {
      if (
        !aAmounts[i] ||
        isNaN(aAmounts[i]) ||
        aAmounts[i] <= 0 ||
        !Number.isInteger(Number(aAmounts[i]))
      ) {
        toastr.warning("valid amounts required");
        return;
      }
    }
    if (aIds.length !== aAmounts.length) {
      toastr.warning("Length Mismatch");
      return;
    }
    if (!aAccount) {
      await connectMetamask();
    } else {
      chainId = await web3.eth.getChainId();
      await checkNetwork(chainId);
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
      let oErrorJSON = JSON.parse(
        error.message.substr(
          error.message.indexOf("{"),
          error.message.lastIndexOf("}")
        )
      );
      const oError = oErrorJSON.originalError.message;
      toastr.error(oError);
    }
    $("#mintBatchBtn").prop("disabled", false);
  }
}

async function burnBatch() {
  try {
    const ids = $("#burnIds").val();
    const amounts = $("#burnAmounts").val();

    const aIds = ids.split(",").map(Number);
    const aAmounts = amounts.split(",").map(Number);
    toastr.clear();
    for (let i = 0; i < aIds.length; i++) {
      if (
        !aIds[i] ||
        isNaN(aIds[i]) ||
        aIds[i] <= 0 ||
        !Number.isInteger(Number(aIds[i]))
      ) {
        toastr.warning("valid token Ids required");
        return;
      }
    }
    for (let i = 0; i < aAmounts.length; i++) {
      if (
        !aAmounts[i] ||
        isNaN(aAmounts[i]) ||
        aAmounts[i] <= 0 ||
        !Number.isInteger(Number(aAmounts[i]))
      ) {
        toastr.warning("valid amounts required");
        return;
      }
    }
    if (aIds.length !== aAmounts.length) {
      toastr.warning("Length Mismatch");
      return;
    }
    if (!aAccount) {
      await connectMetamask();
    } else {
      chainId = await web3.eth.getChainId();
      await checkNetwork(chainId);
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
      let oErrorJSON = JSON.parse(
        error.message.substr(
          error.message.indexOf("{"),
          error.message.lastIndexOf("}")
        )
      );
      const oError = oErrorJSON.originalError.message;
      toastr.error(oError);
    }
    $("#burnBatchBtn").prop("disabled", false);
  }
}

async function safeBatchTransferFrom() {
  try {
    const addressFrom = $("#BatchTransferFrom").val();
    const addressTo = $("#BatchTransferTo").val();
    const ids = $("#BatchTransferIds").val();
    const amounts = $("#BatchTransferAmounts").val();
    const aIds = ids.split(",").map(Number);
    const aAmounts = amounts.split(",").map(Number);
    toastr.clear();
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
      if (
        !aIds[i] ||
        isNaN(aIds[i]) ||
        aIds[i] <= 0 ||
        !Number.isInteger(Number(aIds[i]))
      ) {
        toastr.warning("valid token Ids required");
        return;
      }
    }
    for (let i = 0; i < aAmounts.length; i++) {
      if (
        !aAmounts[i] ||
        isNaN(aAmounts[i]) ||
        aAmounts[i] <= 0 ||
        !Number.isInteger(Number(aAmounts[i]))
      ) {
        toastr.warning("valid amounts required");
        return;
      }
    }
    if (aIds.length !== aAmounts.length) {
      toastr.warning("Length Mismatch");
      ismatch;
      return;
    }

    if (!aAccount) {
      await connectMetamask();
    } else {
      chainId = await web3.eth.getChainId();
      await checkNetwork(chainId);
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
      let oErrorJSON = JSON.parse(
        error.message.substr(
          error.message.indexOf("{"),
          error.message.lastIndexOf("}")
        )
      );
      const oError = oErrorJSON.originalError.message;
      toastr.error(oError);
    }
    $("#safeBatchTransferFromBtn").prop("disabled", false);
  }
}

async function checkNetwork(chainId) {
  if (chainId !== sepoliaChainId) {
    let newChainId = web3.utils.toHex(sepoliaChainId);

    await window.ethereum.request({
      method: "wallet_switchEthereumChain",
      params: [{ chainId: newChainId }],
    });
    toastr.success("network switched successfully");
    chainId = await web3.eth.getChainId();
    $("#network").text("ChainId: " + chainId);
  }
}
