pragma solidity >=0.5.0 <0.6.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract EventLottery is Ownable {
  event onRegisterApplicant(address _address, uint32 _member_srl);
  event onVerifyApplicant(address _address);

  struct Player {
    address addr; // address
    uint32 member_srl; // member_srl of player
  }

  Player[] public Applicants;

  Player[] public VerifiedPlayers;

  // address to Applicant
  mapping (address => uint32) public AddressToApplicant;

  // address to Player
  mapping (address => uint32) public AddressToPlayer;

  // member_srl to address
  mapping (uint32 => address) public MemberSrlToAddress;

  // address to member_srl
  mapping (address => uint32) public AddressToMemberSrl;

  // register or update user address
  function register(uint32 _member_srl, address _address) public onlyOwner {
    //require(_address.balance >= 1000 ether);
    require(MemberSrlToAddress[_member_srl] == address(0));
    require(AddressToMemberSrl[_address] == 0);

    uint32 userId;

    MemberSrlToAddress[_member_srl] = _address;
    AddressToMemberSrl[_address] = _member_srl;
    uint id = Applicants.push(Player(_address, _member_srl));
    userId = uint32(id);

    AddressToApplicant[_address] = userId;

    emit onRegisterApplicant(_address, _member_srl);
  }

  // sending Eth to enter lottery: payable function type
  function verify() public {
    require(msg.sender.balance >= 1000 ether); // player's balnce >= 1000 ether
    require(AddressToApplicant[msg.sender] != 0);

    uint32 member_srl = AddressToMemberSrl[msg.sender];
    require(member_srl > 0);

    uint32 id = AddressToApplicant[msg.sender] - 1;

    uint uid = VerifiedPlayers.push(Applicants[id]);
    AddressToPlayer[msg.sender] = uint32(uid);

    emit onVerifyApplicant(msg.sender);
  }
}
