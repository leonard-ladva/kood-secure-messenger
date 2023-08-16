import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:relay/app/app.dart';
import 'package:relay/helpers/helpers.dart';
import 'package:relay/onboarding_flow/onboarding_flow.dart';
import 'package:relay/profile_setup/profile_setup.dart';

final Map<NameValidationError, String> _nameErrors = {
  NameValidationError.invalid: 'Name is invalid',
  NameValidationError.cantBeEmpty: 'Name can\'t be empty',
  NameValidationError.tooShort: 'Name is too short',
  NameValidationError.tooLong: 'Name is too long',
  NameValidationError.invalidCharacters:
      'Name can only contain letters, numbers and spaces',
};

class ProfileSetupForm extends StatelessWidget {
  const ProfileSetupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocListener<ProfileSetupCubit, ProfileSetupState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          context
              .read<OnboardingFlowCubit>()
              .setStatus(user, OnboardingFlowStatus.appLockSetup);

          context.flow<OnboardingFlowStatus>().update(
                (_) => context.read<OnboardingFlowCubit>().state.status,
              );
          return;
        }
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Profile save Failure'),
              ),
            );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32.0,
        ),
        child: Align(
          alignment: Alignment(0, -1 / 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Setup your profile',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              _PhotoInput(),
              const SizedBox(height: 32),
              _NameInput(),
              const SizedBox(height: 16),
              _SubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextField(
          key: const Key('profileSetupForm_nameInput_textField'),
          autofillHints: [AutofillHints.name],
          onChanged: (name) =>
              context.read<ProfileSetupCubit>().nameChanged(name),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              hintText: 'name',
              errorText: _nameErrors[state.name.displayError]),
        );
      },
    );
  }
}

class _PhotoInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
      buildWhen: (previous, current) =>
          previous.photo != current.photo || previous.name != current.name,
      builder: (context, state) {
        return GestureDetector(
          onTap: () => context.read<ProfileSetupCubit>().pickImageClicked(),
          child: CircleAvatar(
            foregroundImage:
                state.photo == null ? null : FileImage(state.photo!),
            radius: 75,
            backgroundColor: Color(0xFFb8e986),
            child: Text(
              initials(
                state.name.value.length > 0 ? state.name.value : 'a b',
              ),
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Color(0xFF528617),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                onPressed: state.isValid
                    ? () => context
                        .read<ProfileSetupCubit>()
                        .submitUserProfileData()
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Save',
                  ),
                ),
              );
      },
    );
  }
}
