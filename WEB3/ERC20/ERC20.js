let web3;
const contractABI = [
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
        name: "spender",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "value",
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
        name: "value",
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
        name: "owner",
        type: "address",
      },
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
    ],
    name: "allowance",
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
        name: "spender",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "approve",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
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
        name: "amount",
        type: "uint256",
      },
    ],
    name: "burn",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "decimals",
    outputs: [
      {
        internalType: "uint8",
        name: "",
        type: "uint8",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "subtractedValue",
        type: "uint256",
      },
    ],
    name: "decreaseAllowance",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "addedValue",
        type: "uint256",
      },
    ],
    name: "increaseAllowance",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
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
    inputs: [],
    name: "totalSupply",
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
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "transfer",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
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
        name: "amount",
        type: "uint256",
      },
    ],
    name: "transferFrom",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
];
const contractAddress = "0xC4CD7FA609b29F03Dc43C18404671868f612719B";
let oContract;

let account = "";
async function connectMetamask() {
  if (window.ethereum) {
    try {
      web3 = new Web3(window.ethereum);
      oContract = new web3.eth.Contract(contractABI, contractAddress);
      const accounts = await window.ethereum.request({
        method: "eth_requestAccounts",
      });
      if (accounts.length > 0) {
        alert("Wallet connected successfully");
        $("#account").text("Address:" + accounts[0]);
        account = accounts[0];
        alldetails(account);
        $("#connectBtn").hide();
        $("#disConnectBtn").show();
      }

      web3.eth.currentProvider.on("accountsChanged", function (accounts) {
        if (accounts.length === 0) {
          location.reload();
        } else {
          $("#account").text("Address: " + accounts[0]);
        }
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
    if (!account) await connectMetamask();
    let mintAmount = $("#mint").val();
    if (mintAmount === "" || isNaN(mintAmount) || mintAmount <= 0) {
      $("#errormint").text("A valid amount is required");
      $("#errormint").show();
      return;
    } else {
      $("#errormint").hide();
    }
    const weiValue = Web3.utils.toWei(mintAmount, "ether");

    const estGas = await oContract.methods
      .mint(weiValue)
      .estimateGas({ from: account });

    console.log(estGas);
    await oContract.methods.mint(weiValue).send({ from: account, gas: estGas });
    await alldetails(account);
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
    if (!account) await connectMetamask();
    let burnmounts = $("#burn").val();
    if (burnmounts === "" || isNaN(burnmounts) || burnmounts <= 0) {
      $("#errorburn").text("A valid amount is required");
      $("#errorburn").show();
      return;
    } else {
      $("#errorburn").hide();
    }
    const weiValue = Web3.utils.toWei(burnmounts, "ether");
    const estGas = await oContract.methods
      .burn(weiValue)
      .estimateGas({ from: account });

    console.log(estGas);

    await oContract.methods.burn(weiValue).send({ from: account, gas: estGas });
    await alldetails(account);
  } catch (error) {
    if (error.message.includes("User denied")) {
      alert("You rejected the transaction on Metamask!");
    } else {
      alert(error);
    }
  }
}

async function transfer() {
  try {
    if (!account) await connectMetamask();

    let address = $("#transferTO").val();
    let amount = $("#transferAmount").val();

    if (!web3.utils.isAddress(address)) {
      $("#errorTO").text("A valid address is required");
      $("#errorTO").show();
      return;
    } else {
      $("#errorTO").hide();
    }

    if (amount === "" || isNaN(amount) || amount <= 0) {
      $("#errorAmount").text("A valid amount is required");
      $("#errorAmount").show();
      return;
    } else {
      $("#errorAmount").hide();
    }
    if (address === account) {
      swal(swal("Oops", "owner can't be recipient", "error"));
      return;
    }
    const weiValue = Web3.utils.toWei(amount, "ether");
    const estGas = await oContract.methods
      .transfer(address, weiValue)
      .estimateGas({ from: account });

    console.log(estGas);

    await oContract.methods
      .transfer(address, weiValue)
      .send({ from: account, gas: estGas });
    await alldetails(account);
  } catch (error) {
    if (error.message.includes("User denied")) {
      alert("You rejected the transaction on Metamask!");
      return;
    } else {
      alert(error);
    }
  }
}

async function approve() {
  try {
    if (!account) await connectMetamask();
    let address = $("#approveAddress").val();
    let amount = $("#approveAmount").val();
    if (!web3.utils.isAddress(address)) {
      $("#errorapproveAddr").text("A valid address is required");
      $("#errorapproveAddr").show();
      return;
    } else {
      $("#errorapproveAddr").hide();
    }

    if (amount === "" || isNaN(amount) || amount <= 0) {
      $("#errorapproveAmt").text("A valid amount is required");
      $("#errorapproveAmt").show();
      return;
    } else {
      $("#errorapproveAmt").hide();
    }

    const weiValue = Web3.utils.toWei(amount, "ether");
    console.log("Allowance" + amount + "ETH");
    const estGas = await oContract.methods
      .approve(address, weiValue)
      .estimateGas({ from: account });

    console.log(estGas);
    await oContract.methods
      .approve(address, weiValue)
      .send({ from: account, gas: estGas });
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
    if (!account) await connectMetamask();
    const addressFrom = $("#addressFrom").val();
    const addressTo = $("#addressTo").val();
    const amount = $("#transferFromAmount").val();

    if (
      !web3.utils.isAddress(addressFrom) ||
      !web3.utils.isAddress(addressTo)
    ) {
      swal({
        text: "A valid address is required",
      });
      return;
    }
    if (addressTo === account) {
      swal(swal("Oops", "owner can't be recipient", "error"));
      return;
    }
    if (amount === "" || isNaN(amount) || amount <= 0) {
      swal({
        text: "A valid amount is required",
      });
      return;
    }
    const weiValue = Web3.utils.toWei(amount, "ether");

    if (addressFrom == account) {
      const estGas = await oContract.methods
        .transfer(addressTo, weiValue)
        .estimateGas({ from: account });

      console.log(estGas);

      await oContract.methods
        .transfer(addressTo, weiValue)
        .send({ from: account, gas: estGas });
    } else {
      const estGas = await oContract.methods
        .transferFrom(addressFrom, addressTo, weiValue)
        .estimateGas({ from: account });

      console.log(estGas);

      await oContract.methods
        .transferFrom(addressFrom, addressTo, weiValue)
        .send({ from: account, gas: estGas });
    }
    await alldetails(account);
  } catch (error) {
    if (error.message.includes("User denied")) {
      alert("You rejected the transaction on Metamask!");
    } else {
      alert(error);
      console.log(error.message);
    }
  }
}

async function alldetails(address) {
  const balance = await oContract.methods.balanceOf(address).call();
  $("#balance").text("Balance: " + balance + "Wei");

  const name = await oContract.methods.name().call();
  $("#tname").text("TokenName: " + name);

  const symbol = await oContract.methods.symbol().call();
  $("#tsymbol").text("TokenSymbol: " + symbol);
}
