class Register {
  String name;
  int address;
  Map<String, Bits> bits = {};

  Register(this.name, this.address);

  addBits(String name, String mask, Map<dynamic, String> adapter) {
    bits[name] = Bits(name, mask, adapter);
  }

  @override String toString() {
    return "Register:{name:$name, address:$address, bits:$bits}\n";
  }
}

class Bits {
  String name;
  final String _mask;
  List<int> bitNumbers = [];
  Map<dynamic, String> adapter;

  Bits(this.name, this._mask, this.adapter) {
    for (int maskIndex = _mask.length - 1, bitNumberIndex = 0; maskIndex >= 0; maskIndex--, bitNumberIndex++) {
      if (_mask[maskIndex] == '1') {
        bitNumbers.add(bitNumberIndex);
      }
    }
  }

  @override String toString() {
    return "Bits:{name:$name, mask:$_mask, bitNumbers:$bitNumbers, adapter:$adapter}\n";
  }

  get mask => _mask;
}

class BitwiseUtils {
  static int setBit(int byte, int bitNumber) {
    return byte | 1 << bitNumber;
  }
  static int clearBit(int byte, int bitNumber) {
    return byte & ~(1 << bitNumber);
  }
  static int toggleBit(int byte, int bitNumber) {
    return byte ^ 1 << bitNumber;
  }
  static bool isBitSet(int byte, bitNumber) {
    return ((byte >> bitNumber) & 1) == 1;
  }

  static int setBits(int byteValue, Register register, String bitsName, dynamic value) {
    Bits? bits = register.bits[bitsName];
    if (bits == null) {
      throw Exception("Bits $bitsName not mapped for Register ${register.name}");
    }

    if (bits.bitNumbers.length == 1) {
      // set just one bit to true or false
      // value must be boolean
      return _setSingleBit(byteValue, register, bits, value);
    } else {
      // set a group of bits to a value we look up from our adapter map based on supplied value
      return _setMultipleBits(byteValue, register, bits, value);
    }
  }

  static int _setMultipleBits(int byteValue, Register register, Bits bits, dynamic value) {
    String? valueLookup = bits.adapter[value];
    if (valueLookup == null) {
      throw Exception("Value $value is not mapped to a bitmask for ${register.name}.${bits.name}");
    }
    if (valueLookup.length != bits.bitNumbers.length) {
      throw Exception(
          "Bad mapping: looked up $value and got $valueLookup which has length ${valueLookup.length}, but ${register.name}.${bits.name} has mask ${bits.mask} length ${bits.bitNumbers.length}");
    }

    for (int bitNumberIndex = 0, valueIndex = bits.bitNumbers.length - 1;
    bitNumberIndex < bits.bitNumbers.length;
    bitNumberIndex++, valueIndex--) {
      int bitNumber = bits.bitNumbers[bitNumberIndex];
      if (valueLookup[valueIndex] == '1') {
        byteValue = BitwiseUtils.setBit(byteValue, bitNumber);
      } else {
        byteValue = BitwiseUtils.clearBit(byteValue, bitNumber);
      }
    }
    return byteValue;
  }

  static int _setSingleBit(int inputValue, Register register, Bits bits, dynamic value) {
    // value must be boolean
    if (value is! bool) {
      throw Exception("${register.name}.${bits.name} is single bit, value must be boolean but was $value");
    } else {
      int outputValue = inputValue;

      if (value == true) {
        outputValue = BitwiseUtils.setBit(inputValue, bits.bitNumbers[0]);
      } else {
        outputValue = BitwiseUtils.clearBit(inputValue, bits.bitNumbers[0]);
      }

      return outputValue;
    }
  }
}
