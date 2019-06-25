import 'package:bloc/bloc.dart';

import 'guides_bloc_event.dart';
import 'guides_bloc_state.dart';

class GuidesBloc extends Bloc<GuidesEvent, GuidesState> {
  @override
  GuidesState get initialState => null;

  @override
  Stream<GuidesState> mapEventToState(GuidesEvent event) async* {
    if (event == GuidesEvent.Products) {}
    if (event == GuidesEvent.Elements) {}
    if (event == GuidesEvent.Favorite) {}
    if (event == GuidesEvent.Conditions) {}
    if (event == GuidesEvent.Analysis) {}
  }
}
