import React, { Component } from "react";
//import { Tabs, Tab } from 'react-bootstrap';
import Bank from "./contracts/Bank.json";
//import SimpleStorageContract from "./contracts/SimpleStorage.json";

import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { storageValue: 0, web3: null, accounts: null, contract: null };
  async componentWillMount() {
    await this.loadBlockchainData(this.props.dispatch)
  }

  async loadBlockchainData(_dispatch) {
    if(typeof window.ethereum!=='undefined'){
      const web3 = await getWeb3();
      const netId = await web3.eth.net.getId()
      const accounts = await web3.eth.getAccounts(console.log)
      
      // console.log(netId)
      // console.log(accounts[0])
      

      //load balance
      if(typeof accounts[0] !=='undefined'){
        const balance = await web3.eth.getBalance(accounts[0])
        this.setState({account: accounts[0], balance: balance, web3: web3})
      } else {
        window.alert('Please login with MetaMask')
      }

      //load contracts
      try {
        const bank = new web3.eth.Contract(Bank.abi, Bank.networks[netId].address)
        const BankAddress = Bank.networks[netId].address;
        const bb = await bank.methods.getBankBalance().call()
        this.setState({bank: bank, BankAddress: BankAddress, bb})
        
     
      console.log(bb)
      } catch (e) {
        console.log('Error', e)
        window.alert('Contracts not deployed to the current network')
      }
    } else {
      window.alert('Please install MetaMask')
    }

      
  }

  // runExample = async () => {
  //   const { accounts, contract } = this.state;

  //   // Stores a given value, 5 by default.
  //   await contract.methods.set(5).send({ from: accounts[0] });

  //   // Get the value from the contract to prove it worked.
  //   const response = await contract.methods.get().call();

  //   // Update state with the result.
  //   this.setState({ storageValue: response });
  // };

  // 我的
  async deposit(amount) {
    if(this.state.bank!=='undefined'){
      try{
        await this.state.bank.methods.deposit().send({value: amount.toString(), from: this.state.account})
      } catch (e) {
        console.log('Error, deposit: ', e)
      }
    }
  }

  // async withdraw(amount) { // 非同步
  //   if(this.state.bank!=='undefined'){ //  check web3 是否已注入到 MetaMask
  //     try{
  //       await this.state.bank.methods.withdraw().send({value: amount.toString(), from: this.state.account})
  //     } catch(e) {
  //       console.log('Error, withdraw: ', e)
  //     }
  //   }
  // }

  async withdraw(withdrawAmount) {
      await this.state.bank.methods.withdraw(withdrawAmount).send({from: this.state.account })
      .once('receipt', (_receipt) => {
    })
  }


  constructor(props) {
    super(props)
    this.state = {
      web3: 'undefined',
      account: '',
      bank: null,
      balance: 0,
      BankAddress: null,
    }
    this.withdraw = this.withdraw.bind(this)
    this.getBankBalance = this.getBankBalance(this)

  }
  

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      // <div className="App">
      //   <h1>Good to Go!</h1>
      //   <p>Your Truffle Box is installed and ready.</p>
      //   <h2>Smart Contract Example</h2>
      //   <p>
      //     If your contracts compiled and migrated successfully, below will show
      //     a stored value of 5 (by default).
      //   </p>
        
        <div className="container-fluid mt-5 text-center">
            <h1>Welcome, Barbie</h1>
            <h2>{this.state.account}</h2>
            <br></br>
            <div className="row">
              <main role="main" className="col-lg-12 d-flex text-center">
                <div className="content mr-auto ml-auto">
                  <div>
                    <br></br>
                      存錢ㄌ
                      <br></br>
                      min. amount is 1 ETH
                      <br></br>
                      (1 deposit is possible at the time)
                      <br></br>
                      <form onSubmit={(e) => {
                        e.preventDefault()
                        let amount = this.depositAmount.value
                        amount = amount * 10**18 //convert to wei
                        this.deposit(amount)
                      }}>
                        <div className='form-group mr-sm-2'>
                        <br></br>
                          <input
                            id='depositAmount'
                            //step="0.01"
                            type='number'
                            ref={(input) => { this.depositAmount = input }}
                            className="form-control form-control-md"
                            placeholder='amount...'
                            required />
                        </div>
                        <button type='submit' className='btn btn-primary'>DEPOSIT</button>
                      </form>
                      <br></br>
                      領錢ㄌ
                      <br></br>
                      min. amount is 1 ETH
                      <br></br>
                      (1 deposit is possible at the time)
                      <br></br>
                      <form onSubmit={(e) => {
                        e.preventDefault()
                        this.withdraw(this.withdrawAmount.value)
                      }}>
                        <div className='form-group mr-sm-2'>
                        <br></br>
                          <input
                              id='withdrawAmount'
                              //step="0.01"
                              type='number'
                              ref={(input) => { this.withdrawAmount = input }}
                              className="form-control form-control-md"
                              placeholder='amount...'
                              required />
                        </div>
                        <button type='submit' className='btn btn-primary'>WITHDRAW</button>
                      </form>
                      <br></br>
                      現在錢包裡有多少錢？
                      <br></br>
                      <p>{this.state.bb}</p>
                  </div>
                </div>
            </main>
          </div>
        </div>
    );
  }
}

export default App;
