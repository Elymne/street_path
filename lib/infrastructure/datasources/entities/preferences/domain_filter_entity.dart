import 'package:objectbox/objectbox.dart';
import 'package:poc_street_path/domain/models/preferences/domain_filter.model.dart';

@Entity()
class DomainFilterEntity {
  @Id()
  int obId = 0;

  @Unique()
  String id;
  int createdAt;
  String url;

  DomainFilterEntity({required this.id, required this.createdAt, required this.url});

  static DomainFilterEntity fromModel(DomainFilter domainFilter) {
    return DomainFilterEntity(id: domainFilter.id, createdAt: domainFilter.createdAt, url: domainFilter.url);
  }

  DomainFilter toModel() {
    return DomainFilter(id: id, createdAt: createdAt, url: url);
  }
}
