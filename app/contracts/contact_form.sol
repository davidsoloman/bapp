contract ContactForm {
  uint    number;
  bytes32 str;

  function save_contact(uint number_val, bytes32 str_val) {
    number = number_val;
    str    = str_val;
  }

  function read_number() constant returns (uint number_val){
    return number;
  }

  function read_str() constant returns (bytes32 str_val){
    return str;
  }

}
