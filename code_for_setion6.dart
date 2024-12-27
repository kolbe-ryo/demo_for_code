import 'dart:math';

class Damage {
  static const int _MIN_DAMAGE = 0;
  final int amount;

  Damage._(this.amount) {
    if (amount < _MIN_DAMAGE) {
      throw Exception('Damage amount must be greater than $_MIN_DAMAGE');
    }
  }

  factory Damage.calculate({
    required final int attackPower,
    required final int weaponPower,
    required final int enemyDefencePower,
    required final SpecialGuage specialGuage,
  }) {
    final damage = max(
      _MIN_DAMAGE,
      attackPower + weaponPower - enemyDefencePower / 2,
    );
    // specialGuageが満タンの時はダメージを2倍にする
    final calculatedDamage = specialGuage.isFull ? damage * 2 : damage;
    return Damage._(calculatedDamage.toInt());
  }
}

class SpecialGuage {
  static const int _MIN_GUAGE = 0;
  static const int _MAX_GUAGE = 100;
  static const int _INCREASE_AMOUNT = 5;

  final int amount;

  SpecialGuage(this.amount) {
    if (amount < _MIN_GUAGE || amount > _MAX_GUAGE) {
      throw Exception(
          'Special guage must be between $_MIN_GUAGE and $_MAX_GUAGE');
    }
  }

  bool get isFull => amount == _MAX_GUAGE;

  SpecialGuage increase({required final int damageAmount}) {
    final increasedAmount = this.amount + damageAmount / 100 + _INCREASE_AMOUNT;
    final newAmound = min(increasedAmount.toInt(), _MAX_GUAGE);
    return SpecialGuage(newAmound);
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
    if (power < _MIN_POWER || power > _MAX_POWER) {
      throw Exception('Power must be between $_MIN_POWER and $_MAX_POWER');
    }

    if (durability < _MIN_DURABILITY) {
      throw Exception('Durability must be greater than $_MIN_DURABILITY');
    }
  }

  bool get canUse => durability > _MIN_DURABILITY;

  Weapon use({
    required final int damageAmount,
    required final SpecialGuage specialGuage,
  }) {
    if (!canUse) {
      throw Exception('Weapon is broken');
    }

    if (!specialGuage.isFull && damageAmount < _DAMAGE_THRESHOLD) {
      final newDurability = durability - 1;
      return Weapon(name, power, newDurability);
    }

    return this;
  }
}

void main() {
  final weapon = Weapon('Sword', 100, 100);
  final specialGuage = SpecialGuage(10);
  final damage = Damage.calculate(
    attackPower: 100,
    weaponPower: weapon.power,
    enemyDefencePower: 390,
    specialGuage: specialGuage,
  );

  print('Damage amount: ${damage.amount}');

  final newWeapon =
      weapon.use(damageAmount: damage.amount, specialGuage: specialGuage);
  print('Weapon durability: ${newWeapon.durability}');
}
