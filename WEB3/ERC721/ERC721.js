let web3;
let aAccount = "";
let oContract;
let sContractAddress = "0xbA2b8AFfa9fCEef1A1e844faeF13962a17E777F9";
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
    inputs: [],
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
    try {
      web3 = new Web3(window.ethereum);
      oContract = new web3.eth.Contract(contractAbi, sContractAddress);
      const accounts = await window.ethereum.request({
        method: "eth_requestAccounts",
      });
      if (accounts.length) {
        alert("Wallet connected successfully");
        $("#account").text("Address:" + accounts[0]);
        aAccount = accounts[0];
        $("#connectBtn").hide();
        $("#disConnectBtn").show();
        alldetails();
      }

      web3.eth.currentProvider.on("accountsChanged", function (accounts) {
        if (!accounts.length) {
          location.reload();
        } else {
          aAccount = accounts[0];
          $("#account").text("Address: " + aAccount);
          alldetails(aAccount);
        }
      });
      window.ethereum.on('networkChanged', function(networkId){
        console.log('networkChanged',networkId);
      });
      
    } catch (error) {
      console.error("Error connecting to MetaMask:", error);
    }
  } else {
    alert("MetaMask not available");
    window.location.href = "https://metamask.io/";
  }
}
function disConnectMetamask() {
  location.reload();
  alert("Wallet disconnected successfully!");
}

$(document).ready(function () {
  $("#connectBtn").click(function () {
    connectMetamask();
  });
});
$(document).ready(function () {
  $("#disConnectBtn").click(function () {
    disConnectMetamask();
    $("#connectBtn").show();
    $("#disConnectBtn").hide();
  });
});

async function mint() {
  try {
    if (!aAccount) await connectMetamask();
    const estGas = await oContract.methods
      .mint()
      .estimateGas({ from: aAccount });

    console.log(estGas);

    await oContract.methods.mint().send({ from: aAccount, gas: estGas });
    alldetails();
  } catch (error) {
    if (error.message.includes("User denied")) {
      alert("You rejected the transaction on Metamask!");
    } else {
      alert(error);
    }
  }
}

async function burn() {
  try {
    if (!aAccount) await connectMetamask();
    let tokenId = $("#burn").val();
    if (!tokenId || isNaN(tokenId)) {
      swal({
        text: "A valid tokenId is required",
      });
      return;
    }

    const estGas = await oContract.methods
      .burn(tokenId)
      .estimateGas({ from: aAccount });

    console.log(estGas);

    await oContract.methods.burn(tokenId).send({ from: aAccount, gas: estGas });
    alldetails();
  } catch (error) {
    if (error.message.includes("User denied")) {
      alert("You rejected the transaction on Metamask!");
    } else {
      alert(error);
    }
  }
}

async function transferFrom() {
  try {
    if (!aAccount) await connectMetamask();
    const addressFrom = $("#addressFrom").val();
    const addressTo = $("#addressTo").val();
    const tokenId = $("#tokenId").val();

    if (
      !web3.utils.isAddress(addressFrom) ||
      !web3.utils.isAddress(addressTo)
    ) {
      swal({
        text: "A valid address is required",
      });
      return;
    }
    if (addressFrom === addressTo) {
      swal(swal("Oops", "from address and to address are equal", "error"));
      return;
    }
     if (!tokenId || isNaN(tokenId)) { 
      swal({
        text: "A valid tokenId is required",
      });
      return;
    }

    const estGas = await oContract.methods
      .transferFrom(addressFrom, addressTo, tokenId)
      .estimateGas({ from: aAccount });

    console.log(estGas);

    await oContract.methods
      .transferFrom(addressFrom, addressTo, tokenId)
      .send({ from: aAccount, gas: estGas });
    alldetails();
  } catch (error) {
    if (error.message.includes("User denied")) {
      alert("You rejected the transaction on Metamask!");
    } else {
      if (error.message.includes("User denied")) {
        alert("You rejected the transaction on Metamask!");
      } else {
        alert(error);
      }
    }
  }
}

async function ownerOf() {
  try {
    if (!aAccount) await connectMetamask();
    const tokenId = $("#ownerOf").val();
    if (!tokenId || isNaN(tokenId)) {
      swal({
        text: "A valid tokenId is required",
      });
      return;
    }

    console.log(tokenId);
    const address = await oContract.methods.ownerOf(tokenId).call();
    swal({
      text: "owner of token Id:" + tokenId + ":" + address,
    });
  } catch (error) {
    alert(error.message);
  }
}

async function alldetails() {
  const balance = await oContract.methods.balanceOf(aAccount).call();
  $("#balanceOf").text("Total Balance:" + balance);
  const totalTokenId = await oContract.methods.totalTokenId().call();
  $("#totalSupply").text("Total TokenId:" + totalTokenId);
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
      swal({
        text: "A valid address is required",
      });
      return;
    }
    if (aAccount === operator) {
      swal(swal("Oops", "owner can't be operator", "error"));
      return;
    }
    if (!typeof isApprovedForAll === "boolean") {
      swal({
        text: "Please select true or false",
      });
      return;
    }
    console.log(isApprovedForAll);
    const estGas = await oContract.methods
      .setApprovalForAll(operator, isApprovedForAll)
      .estimateGas({ from: aAccount });

    console.log(estGas);

    await oContract.methods
      .setApprovalForAll(operator, isApprovedForAll)
      .send({ from: aAccount, gas: estGas });
  } catch (error) {
    if (error.message.includes("User denied")) {
      alert("You rejected the transaction on Metamask!");
    } else {
      alert(error);
    }
  }
}
async function approve() {
  try {
    if (!aAccount) await connectMetamask();
    const addressTo = $("#approveAddr").val();
    const tokenId = $("#approveTokenId").val();

    if (!web3.utils.isAddress(addressTo)) {
      swal({
        text: "A valid address is required",
      });
      return;
    }

    if (!tokenId || isNaN(tokenId)) {
      swal({
        text: "A valid tokenId is required",
      });
      return;
    }

    const estGas = await oContract.methods
      .approve(addressTo, tokenId)
      .estimateGas({ from: aAccount });

    console.log(estGas);

    await oContract.methods
      .approve(addressTo, tokenId)
      .send({ from: aAccount, gas: estGas });
  } catch (error) {
    if (error.message.includes("User denied")) {
      alert("You rejected the transaction on Metamask!");
    } else {
      alert(error);
    }
  }
}
async function safeTransferFrom() {
  try {
    if (!aAccount) await connectMetamask();
    const addressFrom = $("#safeTransferFrom").val();
    const addressTo = $("#safeTransferTo").val();
    const tokenId = $("#safeTransferTokenId").val();
    console.log(tokenId);
    if (
      !web3.utils.isAddress(addressFrom) ||
      !web3.utils.isAddress(addressTo)
    ) {
      swal({
        text: "A valid address is required",
      });
      return;
    }
    if (addressFrom === addressTo) {
      swal(swal("Oops", "from address and to address are equal", "error"));
      return;
    }
    if (!tokenId || isNaN(tokenId)) {
      swal({
        text: "A valid tokenId is required",
      });
      return;
    }

    const estGas = await oContract.methods
      .safeTransferFrom(addressFrom, addressTo, tokenId)
      .estimateGas({ from: aAccount });

    console.log(estGas);

    await oContract.methods
      .safeTransferFrom(addressFrom, addressTo, tokenId)
      .send({ from: aAccount, gas: estGas });
    alldetails();
  } catch (error) {
    if (error.message.includes("User denied")) {
      alert("You rejected the transaction on Metamask!");
    } else {
      if (error.message.includes("User denied")) {
        alert("You rejected the transaction on Metamask!");
      } else {
        alert(error);
      }
    }
  }
}
