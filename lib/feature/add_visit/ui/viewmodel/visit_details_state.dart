import '../../../../core/utils/failure.dart';
import '../../domain/entities/visit_attachment_entity.dart';

abstract class VisitDetailsState {}

class VisitDetailsInitialState extends VisitDetailsState {}

class VisitDetailsLoadingState extends VisitDetailsState {}

class VisitDetailsSuccessState extends VisitDetailsState {}

class VisitDetailsFailureState extends VisitDetailsState {
  final Failure failure;
  VisitDetailsFailureState(this.failure);
}

class VisitDetailsValidationFailureState extends VisitDetailsState {
  final String messageKey;
  VisitDetailsValidationFailureState(this.messageKey);
}

class VisitDetailsAttachmentsChangedState extends VisitDetailsState {
  final List<VisitAttachmentEntity> attachments;
  VisitDetailsAttachmentsChangedState(this.attachments);
}
