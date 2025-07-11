import '../models/fund.dart';
import '../../data/repositories/fund_repository.dart';

class GetFundByIdUseCase {
  final FundRepository repository;

  GetFundByIdUseCase(this.repository);

  Future<Fund> execute(String id) {
    return repository.getFundById(id);
  }
}
