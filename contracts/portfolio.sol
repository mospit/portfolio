/*
    Basic portfolio smart contract
*/
//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.4;

contract Portfolio {
    event Buy(address indexed _holder, string indexed _name,uint _newAvgPrice, uint _paid, uint _newBalance);
    event Sell(address indexed _holder, string indexed _name,uint _newAvgPrice, uint _proceeds, uint _newBalance);
    mapping(address => mapping(string => Coin)) internal assets;

    struct Coin
    {
        string name;
        uint priceTotal;
        uint avgPricePaid;
        uint totalPaid;
        uint proceeds;
        uint balance;
    }

    function buy(string memory _id,string memory _coin,uint _price,uint  _amount,uint _paid) public
    {
        // CHECK IF THE ID IS AN EMPTY STRING
        bytes memory tempEmptyStringTest = bytes(_id);
        require(tempEmptyStringTest.length > 0,"ID not included");

        assets[msg.sender][_id].name = _coin;
        assets[msg.sender][_id].balance =  assets[msg.sender][_id].balance + _amount;
       assets[msg.sender][_id].totalPaid =  assets[msg.sender][_id].totalPaid  + _paid;
        assets[msg.sender][_id].avgPricePaid = (assets[msg.sender][_id].totalPaid  - assets[msg.sender][_id].proceeds ) / assets[msg.sender][_id].balance;
        
        emit Buy(msg.sender,_coin, _price,assets[msg.sender][_id].totalPaid , assets[msg.sender][_id].balance );
    }

     function sell(string memory _id,string memory _coin,uint ,uint  _amount,uint _proceeds) public
    {
        // CHECK IF THE ID IS AN EMPTY STRING
        bytes memory tempEmptyStringTest = bytes(_id);
        require(tempEmptyStringTest.length > 0,"ID not included");
       
        assets[msg.sender][_id].name = _coin;
        assets[msg.sender][_id].balance =  assets[msg.sender][_id].balance - _amount;
        assets[msg.sender][_id].proceeds =  assets[msg.sender][_id].proceeds + _proceeds;
        assets[msg.sender][_id].avgPricePaid = (assets[msg.sender][_id].avgPricePaid  - assets[msg.sender][_id].proceeds) / assets[msg.sender][_id].balance;

        emit Sell(msg.sender,_coin,assets[msg.sender][_id].avgPricePaid, assets[msg.sender][_id].proceeds, assets[msg.sender][_id].balance);
    }

    function getCoinName(string memory _coin) public view returns( string memory)
    {
        return assets[msg.sender][_coin].name;
    }
     function getBalance(string memory _coin) public view returns( uint balance)
    {
        return assets[msg.sender][_coin].balance;
    }
     function getTotlaPaid(string memory _coin) public view returns( uint totalPaid)
    {
        return assets[msg.sender][_coin].totalPaid;
    }
     function getProceeds(string memory _coin) public view returns( uint proceeds)
    {
        return assets[msg.sender][_coin].proceeds;
    }
     function getAvgPrice(string memory _coin) public view returns( uint avgPrice)
    {
        return (assets[msg.sender][_coin].totalPaid - assets[msg.sender][_coin].proceeds)/ assets[msg.sender][_coin].balance;
    }
}
