import 'dart:math';

class Damage {
  static const int _MIN_DAMAGE = 0;
  final int amount;

  Damage._(this.amount) {
    if (amount < _MIN_DAMAGE) {
      throw Exception('Damage amount must be greater than $_MIN_DAMAGE');
    }
  }

  // Constructor for no damage
  Damage.nothing(int amount) : this.amount = amount;

  factory Damage.calculate({
    required final int attackPower,
    required final int weaponPower,
    required final int enemyDefencePower,
    required final SpecialGauge specialGauge,
  }) {
    final damage = max(
      _MIN_DAMAGE,
      attackPower + weaponPower - enemyDefencePower / 2,
    );
    // specialGaugeが満タンの時はダメージを2倍にする
    final calculatedDamage = specialGauge.isFull ? damage * 2 : damage;
    return Damage._(calculatedDamage.toInt());
  }
}

class SpecialGauge {
  static const int _MIN_GUAGE = 0;
  static const int _MAX_GUAGE = 100;
  static const int _INCREASE_AMOUNT = 5;

  final int amount;

  SpecialGauge(this.amount) {
    if (amount < _MIN_GUAGE || amount > _MAX_GUAGE) {
      throw Exception(
          'Special guage must be between $_MIN_GUAGE and $_MAX_GUAGE');
    }
  }

  bool get isFull => amount == _MAX_GUAGE;

  SpecialGauge increase({required final int damageAmount}) {
    final increasedAmount = this.amount + damageAmount / 100 + _INCREASE_AMOUNT;
    final newAmound = min(increasedAmount.toInt(), _MAX_GUAGE);
    return SpecialGauge(newAmound);
  }
}

class Something {
  final String text;

  const Something._(this.text);

  factory Something.validate(String text) {
    if (text.isEmpty) {
      throw Exception('${text} is nothing.');
    }
    return Something._(text);
  }
}

class Weapon {
  static const int _MIN_DURABILITY = 0;
  static const int _MIN_POWER = 0;
  static const int _MAX_POWER = 100;
  static const int _DAMAGE_THRESHOLD = 10;

  final String name;
  final int power;
  final int durability;

  Weapon(
    this.name,
    this.power,
    this.durability,
  ) {
    if (power < _MIN_POWER || _MAX_POWER < power) {
      throw Exception('Power must be between $_MIN_POWER and $_MAX_POWER');
    }

    if (durability < _MIN_DURABILITY) {
      throw Exception('Durability must be greater than $_MIN_DURABILITY');
    }
  }

  bool get canUse => durability > _MIN_DURABILITY;

  Weapon use({
    required final int damageAmount,
    required final SpecialGauge specialGauge,
  }) {
    if (!canUse) {
      throw Exception('Weapon is broken');
    }

    // SpecialGaugeが満タンの時は耐久力が減らない
    // 自分の攻撃力が弱かったり、敵の防御力が高かったりすると武器の耐久力が減る
    if (!specialGauge.isFull && damageAmount < _DAMAGE_THRESHOLD) {
      final newDurability = durability - 1;
      return Weapon(name, power, newDurability);
    }

    return this;
  }
}

void main() {
  final weapon = Weapon('Sword', 100, 100);
  final specialGauge = SpecialGauge(10);
  final damage = Damage.calculate(
    attackPower: 100,
    weaponPower: weapon.power,
    enemyDefencePower: 390,
    specialGauge: specialGauge,
  );
  print('Damage amount: ${damage.amount}');

  final newWeapon =
      weapon.use(damageAmount: damage.amount, specialGauge: specialGauge);
  print('Weapon durability: ${newWeapon.durability}');

  final newSpecialGauge = specialGauge.increase(damageAmount: damage.amount);
  print('Special guage amount: ${newSpecialGauge.amount}');
}
