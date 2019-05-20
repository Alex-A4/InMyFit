import 'dart:math';

/// Controller that describes water tips.
/// That contains list of tips and method to get next tip
class WaterTipController {
  final List<WaterTip> _tips = [
    WaterTip('Пока мы спим, потребление жидкости прекращается, однако она продолжает расходоваться'
        'При пробуждении, вода будет поддерживать водный баланс и приводить ваше тело "в действие".', 1),
    WaterTip('Когда ваше тело обезвожено, обмен веществ замедляется. Это нарушение '
        'может привести к увеличению веса.', 2),
    WaterTip('Мозг состоит на 90% из воды, поэтому он первым чувствует обезвоживание, '
        'реагируя с уменьшением концентрации и внимания.', 3),
    WaterTip('Вы хотите сохранить свою кожу красивой и молодой?', 4),
    WaterTip('Вода очищает ваше тело, минимизируя влияние токсинов. Ваша имунная система '
        'борется с вирусами и бактериями гораздо активнее.', 5),
    WaterTip('Вода помогает доставлять питательные элементы к клеткам. Только с участием воды '
        'могут быть поглощены элементы и витамины.', 6),
  ];

  WaterTipController() : this.currentTipIndex = 0;

  int currentTipIndex;

  //Get the next tip from list
  WaterTip getNextTip() {
    return _tips[++currentTipIndex % 6];
  }

  //Get the random tip from 0 to 5 inclusive both
  WaterTip initTip() {
    currentTipIndex = Random().nextInt(6);
    return _tips[currentTipIndex];
  }
}

/// Water tip contains information about water
/// There are [tipText] that contains text
/// and [index] that describes index of tip, it must starts with 1
class WaterTip {
  final String tipText;
  final int index;

  WaterTip(this.tipText, this.index);
}
