import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/fund.dart';
import '../../data/repositories/fund_repository.dart';
import '../../domain/usecases/get_funds_usecase.dart';
import '../../domain/usecases/get_fund_by_id_usecase.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/constants/api_constants.dart';

final getFundsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(FundRepository.provider);
  return GetFundsUseCase(repository);
});

final getFundByIdUseCaseProvider = Provider((ref) {
  final repository = ref.watch(FundRepository.provider);
  return GetFundByIdUseCase(repository);
});

class FundsNotifier extends StateNotifier<AsyncValue<List<Fund>>> {
  final GetFundsUseCase _getFundsUseCase;
  
  FundsNotifier(this._getFundsUseCase) : super(const AsyncValue.loading()) {
    fetchFunds();
  }
  
  Future<void> fetchFunds() async {
    state = const AsyncValue.loading();
    try {
      final funds = await _getFundsUseCase.execute();
      state = AsyncValue.data(funds);
    } catch (e, stackTrace) {
      state = AsyncValue.error(
        e is AppError ? e : UnexpectedError(message: 'Failed to fetch funds', cause: e),
        stackTrace,
      );
    }
  }
  
  Future<void> refresh() async {
    return fetchFunds();
  }
}

final fundsProvider = StateNotifierProvider<FundsNotifier, AsyncValue<List<Fund>>>((ref) {
  final useCase = ref.watch(getFundsUseCaseProvider);
  return FundsNotifier(useCase);
});

final fundByIdProvider = FutureProvider.family<Fund, String>((ref, fundId) async {
  final useCase = ref.watch(getFundByIdUseCaseProvider);
  try {
    return await useCase.execute(fundId);
  } catch (e) {
    throw e is AppError ? e : UnexpectedError(message: 'Failed to fetch fund by ID', cause: e);
  }
});
