contract ContactForm {
  bytes32 data;

  function save_contact(bytes32 value) {
    data = value;
  }

  function read_contact() constant returns (bytes32 value){
    return data;
  }
}
