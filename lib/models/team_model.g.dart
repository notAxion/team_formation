// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamModel _$TeamModelFromJson(Map<String, dynamic> json) => TeamModel(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      avatar: json['avatar'] as String,
      domain: $enumDecode(_$DomainEnumMap, json['domain']),
      available: json['available'] as bool,
    );

const _$GenderEnumMap = {
  Gender.female: 'Female',
  Gender.male: 'Male',
  Gender.agender: 'Agender',
  Gender.bigender: 'Bigender',
  Gender.polygender: 'Polygender',
  Gender.nonBinary: 'Non-binary',
  Gender.genderfluid: 'Genderfluid',
  Gender.genderqueer: 'Genderqueer',
};

const _$DomainEnumMap = {
  Domain.sales: 'Sales',
  Domain.finance: 'Finance',
  Domain.marketing: 'Marketing',
  Domain.it: 'IT',
  Domain.management: 'Management',
  Domain.uiDesigning: 'UI Designing',
  Domain.businessDevelopment: 'Business Development',
};
