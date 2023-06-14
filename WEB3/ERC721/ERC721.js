let web3;
let aAccount = "";
let oContract;
let accounts;
let chainId;
let totalMintedTokenId;
const sepoliaChainId = 11155111;
let sContractAddress = "0xe97af1B47820a8b9BdB776338Bb013371d8f35Ae";
let contractAbi = [
  {
    inputs: [
      {
        internalType: "string",
        name: "name",
        type: "string",
      },
      {
        internalType: "string",
        name: "symbol",
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
        name: "owner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "approved",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "Approval",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
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
        indexed: false,
        internalType: "uint256",
        name: "_fromTokenId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "_toTokenId",
        type: "uint256",
      },
    ],
    name: "BatchMetadataUpdate",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "_tokenId",
        type: "uint256",
      },
    ],
    name: "MetadataUpdate",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
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
        indexed: true,
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "Transfer",
    type: "event",
  },
  {
    inputs: [
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
    ],
    name: "approve",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "owner",
        type: "address",
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
        internalType: "uint256",
        name: "tokenId",
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
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "getApproved",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "owner",
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
        internalType: "string",
        name: "tokenURI",
        type: "string",
      },
    ],
    name: "isUriExists",
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
    inputs: [],
    name: "name",
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
  {
    inputs: [
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "ownerOf",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
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
    inputs: [],
    name: "symbol",
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
  {
    inputs: [
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "tokenURI",
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
  {
    inputs: [],
    name: "totalTokenId",
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
    ],
    name: "transferFrom",
    outputs: [],
    stateMutability: "nonpayable",
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
        await alldetails();
        await showToken();
      }
      web3.eth.currentProvider.on("accountsChanged", async function (accounts) {
        if (!accounts.length) {
          location.reload();
        } else {
          aAccount = accounts[0];
          $("#token-container").empty();
          await showToken();
          await alldetails();
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
    let uri = $("#uri").val();
    toastr.clear();

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
    console.log(await oContract.methods.isUriExists(uri).call());

    if (await oContract.methods.isUriExists(uri).call()) {
      toastr.warning("Token already minted with this URI");
      return;
    }

    $("#mintBtn").prop("disabled", true);
    const estimateGas = await oContract.methods
      .mint(uri)
      .estimateGas({ from: aAccount });

    console.log(estimateGas);

    await oContract.methods
      .mint(uri)
      .send({ from: aAccount, gas: estimateGas });
    await alldetails();
    $("#token-container").empty();
    await showToken();
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
      toastr.error(error);
    }
    $("#mintBtn").prop("disabled", false);
  }
}

async function burn() {
  try {
    let tokenId = $("#burn").val();
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
    if (!aAccount) {
      await connectMetamask();
    } else {
      chainId = await web3.eth.getChainId();
      await checkNetwork(chainId);
    }

    $("#BurnBtn").prop("disabled", true);
    const estimateGas = await oContract.methods
      .burn(tokenId)
      .estimateGas({ from: aAccount });

    console.log(estimateGas);

    await oContract.methods
      .burn(tokenId)
      .send({ from: aAccount, gas: estimateGas });
    await alldetails();
    $("#token-container").empty();
    await showToken();
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
    $("#burnBtn").prop("disabled", false);
  }
}

async function transferFrom() {
  try {
    const addressFrom = $("#addressFrom").val();
    const addressTo = $("#addressTo").val();
    const tokenId = $("#tokenId").val();
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
    if (!aAccount) {
      await connectMetamask();
    } else {
      chainId = await web3.eth.getChainId();
      await checkNetwork(chainId);
    }
    $("#transferFromBtn").prop("disabled", true);
    const estimateGas = await oContract.methods
      .transferFrom(addressFrom, addressTo, tokenId)
      .estimateGas({ from: aAccount });

    console.log(estimateGas);

    await oContract.methods
      .transferFrom(addressFrom, addressTo, tokenId)
      .send({ from: aAccount, gas: estimateGas });
    await alldetails();
    $("#token-container").empty();
    await showToken();
    $("#transferFromBtn").prop("disabled", false);
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
    $("#transferFromBtn").prop("disabled", false);
  }
}

async function ownerOf() {
  try {
    const tokenId = $("#ownerOf").val();
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
    if (!aAccount) await connectMetamask();
    const address = await oContract.methods.ownerOf(tokenId).call();
    button;
    toastr.success("owner of token Id:" + tokenId + ":" + address);
  } catch (error) {
    let oErrorJSON = JSON.parse(
      error.message.substr(
        error.message.indexOf("{"),
        error.message.lastIndexOf("}")
      )
    );
    const oError = oErrorJSON.originalError.message;
    toastr.error(oError);
  }
}

async function alldetails() {
  const balance = await oContract.methods.balanceOf(aAccount).call();
  $("#balanceOf").text("Total Balance:" + balance);
  totalMintedTokenId = await oContract.methods.totalTokenId().call();
  $("#totalSupply").text("Total Minted TokenId:" + totalMintedTokenId);
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
    $("#setApprovalForAllBtn").prop("disabled", true);
    const estimateGas = await oContract.methods
      .setApprovalForAll(operator, isApprovedForAll)
      .estimateGas({ from: aAccount });

    console.log(estimateGas);

    await oContract.methods
      .setApprovalForAll(operator, isApprovedForAll)
      .send({ from: aAccount, gas: estimateGas });
    $("#setApprovalForAllBtn").prop("disabled", false);
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
    $("#setApprovalForAllBtn").prop("disabled", false);
  }
}
async function approve() {
  try {
    const addressTo = $("#approveAddr").val();
    const tokenId = $("#approveTokenId").val();
    toastr.clear();
    if (!web3.utils.isAddress(addressTo)) {
      toastr.warning("A valid address is required");
      return;
    }

    if (!tokenId || isNaN(tokenId)) {
      toastr.warning("A valid tokenId is required");
      return;
    }
    if (!aAccount) {
      await connectMetamask();
    } else {
      chainId = await web3.eth.getChainId();
      await checkNetwork(chainId);
    }
    $("#approveBtn").prop("disabled", true);
    const estimateGas = await oContract.methods
      .approve(addressTo, tokenId)
      .estimateGas({ from: aAccount });

    console.log(estimateGas);

    await oContract.methods
      .approve(addressTo, tokenId)
      .send({ from: aAccount, gas: estimateGas });
    $("#approveBtn").prop("disabled", false);
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
    $("#setApprovalForAllBtn").prop("disabled", false);
  }
}

async function safeTransferFrom() {
  try {
    const addressFrom = $("#safeTransferFrom").val();
    const addressTo = $("#safeTransferTo").val();
    const tokenId = $("#safeTransferTokenId").val();
    console.log(tokenId);
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
      swal({
        text: "A valid tokenId is required",
      });
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
    if (!aAccount) {
      await connectMetamask();
    } else {
      chainId = await web3.eth.getChainId();
      await checkNetwork(chainId);
    }
    $("#safeTransferFromBtn").prop("disabled", true);
    const estimateGas = await oContract.methods
      .safeTransferFrom(addressFrom, addressTo, tokenId)
      .estimateGas({ from: aAccount });

    console.log(estimateGas);

    await oContract.methods
      .safeTransferFrom(addressFrom, addressTo, tokenId)
      .send({ from: aAccount, gas: estimateGas });
    await alldetails();
    $("#token-container").empty();
    await showToken();
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
    $("#setApprovalForAllBtn").prop("disabled", false);
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
  } else {
    const container = $("#token-container");
    for (let id = 0; id < tokens.length; id++) {
      const tokenId = tokens[id];
      const uri = await oContract.methods.tokenURI(tokenId).call();
      const response = await fetch(uri);
      const jsonData = await response.json();

      const newCard = $("<div>")
        .attr("id", id)
        .addClass("card")
        .css("width", "18rem");
      newCard.append(
        $("<img>")
          .attr("src", jsonData.image)
          .addClass("card-img-top")
          .attr("alt", "NFT IMAGE"),
        $("<div>")
          .addClass("card-body")
          .append(
            $("<h5>")
              .addClass("card-title")
              .text("Id: " + tokenId),
            $("<h5>")
              .addClass("card-title")
              .text("Name: " + jsonData.name),
              $("<h5>")
              .addClass("card-title")
              .text("Description: " + jsonData.description)
          )
      );
      container.append(newCard);
    }
  }
}
