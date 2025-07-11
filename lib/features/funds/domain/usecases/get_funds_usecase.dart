import '../models/fund.dart';
import '../../data/repositories/fund_repository.dart';

class GetFundsUseCase {
  final FundRepository repository;

  GetFundsUseCase(this.repository);

  Future<List<Fund>> execute() {
    return repository.getFunds();
  }
}
