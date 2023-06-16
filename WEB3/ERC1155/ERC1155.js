let web3;
let aAccount = "";
let oContract;
let accounts;
let chainId;
let estimateGas;
const sepoliaChainId = 11155111;
let sContractAddress = "0xebA9c81A47D7edE38668e44cECb2B749539cc002";
let contractAbi = [
  {
    inputs: [],
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
    inputs: [
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "quantity",
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
        name: "quantitys",
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
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "quantity",
        type: "uint256",
      },
      {
        internalType: "string",
        name: "tokenURI",
        type: "string",
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
        name: "quantitys",
        type: "uint256[]",
      },
      {
        internalType: "string[]",
        name: "uris",
        type: "string[]",
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
        name: "tokenId",
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
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    name: "_isUriExists",
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
        internalType: "address",
        name: "ownerAddress",
        type: "address",
      },
    ],
    name: "ownerOfIds",
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
        name: "tokenId",
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
        $("#token-container").empty();
        await showToken();
        $("#connectBtn").hide();
        $("#disConnectBtn").show();
      }

      web3.eth.currentProvider.on("accountsChanged", async function (accounts) {
        if (!accounts.length) {
          location.reload();
        } else {
          aAccount = accounts[0];
          $("#token-container").empty();
          await showToken();
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
    let uri = $("#uri").val();
    console.log(uri);
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
    if (!validateURI(uri)) {
      toastr.warning("A valid uri is required");
      return;
    }
    if (!aAccount) {
      await connectMetamask();
    } else {
      chainId = await web3.eth.getChainId();
      await checkNetwork(chainId);
    }
    const _isUriExists = await oContract.methods._isUriExists(uri).call();
    if (_isUriExists) {
      console.log(_isUriExists);
      toastr.warning("URI already exists use mint with out uri");
      return;
    }
    $("#mintBtn").prop("disabled", true);
    try {
      estimateGas = await oContract.methods
        .mint(tokenId, mintQuantity, uri)
        .estimateGas({ from: aAccount });
      console.log(estimateGas);
    } catch (error) {
      let oErrorJSON = JSON.parse(
        error.message.substr(
          error.message.indexOf("{"),
          error.message.lastIndexOf("}")
        )
      );
      const oError = oErrorJSON.originalError.message;
      if (error.message.includes("ERC1155")) {
        toastr.error(oError);
      } else {
        toastr.error(error.message);
      }

      $("#mintBtn").prop("disabled", false);
      return;
    }

    await oContract.methods
      .mint(tokenId, mintQuantity, uri)
      .send({ from: aAccount, gas: estimateGas });

    $("#token-container").empty();
    await showToken();
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
    try {
      estimateGas = await oContract.methods
        .burn(tokenId, burnQuantity)
        .estimateGas({ from: aAccount });
      console.log(estimateGas);
      $("#BurnBtn").prop("disabled", true);
    } catch (error) {
      let oErrorJSON = JSON.parse(
        error.message.substr(
          error.message.indexOf("{"),
          error.message.lastIndexOf("}")
        )
      );
      const oError = oErrorJSON.originalError.message;
      if (error.message.includes("ERC1155")) {
        toastr.error(oError);
      } else {
        toastr.error(error.message);
      }
      $("#BurnBtn").prop("disabled", false);
      return;
    }

    await oContract.methods
      .burn(tokenId, burnQuantity)
      .send({ from: aAccount, gas: estimateGas });
    $("#token-container").empty();
    await showToken();
    $("#BurnBtn").prop("disabled", false);
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
    if (!aAccount) {
      await connectMetamask();
    } else {
      chainId = await web3.eth.getChainId();
      await checkNetwork(chainId);
    }
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
    if (!aAccount) {
      await connectMetamask();
    } else {
      chainId = await web3.eth.getChainId();
      await checkNetwork(chainId);
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

    try {
      estimateGas = await oContract.methods
        .setApprovalForAll(operator, isApprovedForAll)
        .estimateGas({ from: aAccount });

      console.log(estimateGas);
    } catch (error) {
      let oErrorJSON = JSON.parse(
        error.message.substr(
          error.message.indexOf("{"),
          error.message.lastIndexOf("}")
        )
      );
      const oError = oErrorJSON.originalError.message;
      if (error.message.includes("ERC1155")) {
        toastr.error(oError);
      } else {
        toastr.error(error.message);
      }
      $("#setApprovalBtn").prop("disabled", false);
      return;
    }

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
      !Number.isInteger(Number(amount))
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
    try {
      estimateGas = await oContract.methods
        .safeTransferFrom(addressFrom, addressTo, tokenId, amount, "0x0000")
        .estimateGas({ from: aAccount });

      console.log(estimateGas);
    } catch (error) {
      let oErrorJSON = JSON.parse(
        error.message.substr(
          error.message.indexOf("{"),
          error.message.lastIndexOf("}")
        )
      );
      const oError = oErrorJSON.originalError.message;
      if (error.message.includes("ERC1155")) {
        toastr.error(oError);
      } else {
        toastr.error(error.message);
      }
      $("#safeTransferFromBtn").prop("disabled", false);
      return;
    }
    await oContract.methods
      .safeTransferFrom(addressFrom, addressTo, tokenId, amount, "0x0000")
      .send({ from: aAccount, gas: estimateGas });
    $("#token-container").empty();
    await showToken();
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
    const ids = $("#mintIds").val();
    const amounts = $("#mintAmounts").val();
    const uris = $("#mintUris").val();

    const aIds = ids.split(",").map(Number);
    const aAmounts = amounts.split(",").map(Number);
    const aUris = uris.split(",");

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
    for (let i = 0; i < aUris.length; i++) {
      if (!validateURI(aUris[i])) {
        toastr.warning("A valid uri is required");
        return;
      }
    }
    if (aIds.length !== aAmounts.length) {
      toastr.warning("Length Mismatch");
      return;
    }
    if (aIds.length !== aUris.length) {
      toastr.warning("Length Mismatch");
      return;
    }
    if (!aAccount) {
      await connectMetamask();
    } else {
      chainId = await web3.eth.getChainId();
      await checkNetwork(chainId);
    }
    for (let i = 0; i < aUris.length; i++) {
      const _isUriExists = await oContract.methods
        ._isUriExists(aUris[i])
        .call();
      if (_isUriExists) {
        toastr.warning("URI already exists use mintBatch with out uri");
        return;
      }
    }

    $("#mintBatchBtn").prop("disabled", true);

    try {
      estimateGas = await oContract.methods
        .mintBatch(aIds, aAmounts, aUris)
        .estimateGas({ from: aAccount });

      console.log(estimateGas);
    } catch (error) {
      let oErrorJSON = JSON.parse(
        error.message.substr(
          error.message.indexOf("{"),
          error.message.lastIndexOf("}")
        )
      );

      if (error.message.includes("ERC1155")) {
        let oError = oErrorJSON.originalError.message;
        toastr.error(oError);
      } else {
        toastr.error(error.message);
      }
      $("#mintBatchBtn").prop("disabled", false);
      return;
    }

    await oContract.methods
      .mintBatch(aIds, aAmounts, aUris)
      .send({ from: aAccount, gas: estimateGas });
    $("#token-container").empty();
    await showToken();
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

    try {
      estimateGas = await oContract.methods
        .burnBatch(aIds, aAmounts)
        .estimateGas({ from: aAccount });

      console.log(estimateGas);
    } catch (error) {
      let oErrorJSON = JSON.parse(
        error.message.substr(
          error.message.indexOf("{"),
          error.message.lastIndexOf("}")
        )
      );
      const oError = oErrorJSON.originalError.message;
      if (error.message.includes("ERC1155")) {
        toastr.error(oError);
      } else {
        toastr.error(error.message);
      }
      $("#burnBatchBtn").prop("disabled", false);
      return;
    }
    await oContract.methods
      .burnBatch(aIds, aAmounts)
      .send({ from: aAccount, gas: estimateGas });
    $("#token-container").empty();
    await showToken();
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

    try {
      estimateGas = await oContract.methods
        .safeBatchTransferFrom(addressFrom, addressTo, aIds, aAmounts, "0x0000")
        .estimateGas({ from: aAccount });

      console.log(estimateGas);
    } catch (error) {
      let oErrorJSON = JSON.parse(
        error.message.substr(
          error.message.indexOf("{"),
          error.message.lastIndexOf("}")
        )
      );
      const oError = oErrorJSON.originalError.message;
      if (error.message.includes("ERC1155")) {
        toastr.error(oError);
      } else {
        toastr.error(error.message);
      }
      $("#safeBatchTransferFromBtn").prop("disabled", false);
      return;
    }
    await oContract.methods
      .safeBatchTransferFrom(addressFrom, addressTo, aIds, aAmounts, "0x0000")
      .send({ from: aAccount, gas: estimateGas });
    $("#token-container").empty();
    await showToken();
    $("#safeBatchTransferFromBtn").prop("disabled", false);
  } catch (error) {
    if (error.message.includes("User denied")) {
      toastr.warning("You rejected the transaction on Metamask!");
    } else {
      toastr.error(error.message);
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

function validateURI(uri) {
  try {
    new URL(uri);
    return true;
  } catch (error) {
    return false;
  }
}

async function showToken() {
  const tokens = await oContract.methods.ownerOfIds(aAccount).call();
  if (tokens.length === 0) {
    return;
  } else
    try {
      {
        let response;
        for (let id = 0; id < tokens.length; id++) {
          const tokenId = tokens[id];
          const balanceOf = await oContract.methods
            .balanceOf(aAccount, tokens[id])
            .call();
          const uri = await oContract.methods.uri(tokenId).call();
          try {
            response = await fetch(uri);
          } catch (error) {
            toastr.error(error.message);
            return;
          }
          const jsonData = await response.json();

          $("#token-container").append(`
          <div id=${id} class="card" style="width: 18rem;">
            <img src="${jsonData.image}" class="card-img-top" alt="NFT IMAGE">
            <div class="card-body">
              <h5 class="card-title">ID: ${tokenId}</h5>
              <h5 class="card-title">Name: ${jsonData.name}</h5>
              <h5 class="card-title">Quantity: ${balanceOf}</h5>
              <h5 class="card-title">Description: ${jsonData.description}</h5>
            </div>
          </div>
        `);
        }
      }
    } catch (error) {
      toastr.error(error.message);
    }
}
async function WithOutUri() {
  try {
    const tokenId = $("#WithOutUriId").val();
    const mintQuantity = $("#WithOutUriAmount").val();

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
    const uri = await oContract.methods.uri(tokenId).call();
    const _isUriExists = await oContract.methods._isUriExists(uri).call();
    if (!_isUriExists) {
      toastr.warning("URI not exists use mint with uri");
      return;
    }
    $("#WithOutUriBtn").prop("disabled", true);

    try {
      estimateGas = await oContract.methods
        .mint(tokenId, mintQuantity, "")
        .estimateGas({ from: aAccount });
      console.log(estimateGas);
    } catch (error) {
      let oErrorJSON = JSON.parse(
        error.message.substr(
          error.message.indexOf("{"),
          error.message.lastIndexOf("}")
        )
      );
      const oError = oErrorJSON.originalError.message;
      if (error.message.includes("ERC1155")) {
        toastr.error(oError);
   
      } else {
        toastr.error(error.message);

        $("#WithOutUriBtn").prop("disabled", false);
        return;
      }
    }
    await oContract.methods
      .mint(tokenId, mintQuantity, "")
      .send({ from: aAccount, gas: estimateGas });
    $("#token-container").empty();
    await showToken();
    $("#WithOutUriBtn").prop("disabled", false);
  } catch (error) {
    if (error.message.includes("User denied")) {
      toastr.warning("You rejected the transaction on Metamask!");
    } else {
      toastr.error(error.message);
    }
    $("#WithOutUriBtn").prop("disabled", false);
  }
}
async function WithOutUriBatch() {
  try {
    const ids = $("#withOutUriIdsBatch").val();
    const amounts = $("#withOutUriAmountsBatch").val();

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
    for (let i = 0; i < aIds.length; i++) {
      const uri = await oContract.methods.uri(aIds[i]).call();

      const _isUriExists = await oContract.methods._isUriExists(uri).call();

      if (!_isUriExists) {
        toastr.warning("URI not exists use mintBatch with uri");
        return;
      }
    }

    $("#mintBatchBwithOutUriBatchBtntn").prop("disabled", true);

    try {
      estimateGas = await oContract.methods
        .mintBatch(aIds, aAmounts, [])
        .estimateGas({ from: aAccount });

      console.log(estimateGas);
    } catch (error) {
      let oErrorJSON = JSON.parse(
        error.message.substr(
          error.message.indexOf("{"),
          error.message.lastIndexOf("}")
        )
      );
      const oError = oErrorJSON.originalError.message;
      if (error.message.includes("ERC1155")) {
        toastr.error(oError);
       
      } else {
        toastr.error(error.message);
      }

      $("#withOutUriBatchBtn").prop("disabled", false);
      return;
    }

    await oContract.methods
      .mintBatch(aIds, aAmounts, [])
      .send({ from: aAccount, gas: estimateGas });
    $("#token-container").empty();
    await showToken();
    $("#withOutUriBatchBtn").prop("disabled", false);
  } catch (error) {
    if (error.message.includes("User denied")) {
      toastr.warning("You rejected the transaction on Metamask!");
    } else {
      toastr.error(error.message);
    }
    $("#withOutUriBatchBtn").prop("disabled", false);
  }
}
