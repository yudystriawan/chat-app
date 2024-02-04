import 'package:core/styles/typography.dart';
import 'package:core/widgets/clickable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Terms of Service',
          style: AppTypography.heading2,
        ),
        const Divider(),
        const TermsOfServiceContent(
          title: Text('1. Acceptance of Terms'),
          body: Text(
            'By downloading, installing, or using Chatapp, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the app.',
          ),
        ),
        4.verticalSpaceFromWidth,
        const TermsOfServiceContent(
          title: Text('2. Google Account Integration'),
          body: Text(
            "Chatapp utilizes Google Account sign-in for user authentication. By signing in with your Google Account, you agree to adhere to Google's Terms of Service (https://policies.google.com/terms) and Privacy Policy (https://policies.google.com/privacy).",
          ),
        ),
        4.verticalSpaceFromWidth,
        const TermsOfServiceContent(
          title: Text('3. User Conduct'),
          body: Text(
            'Users are solely responsible for their conduct while using Chatapp. Any violation of these Terms may result in the termination of your account.',
          ),
        ),
        4.verticalSpaceFromWidth,
        const TermsOfServiceContent(
          title: Text('4. Intellectual Property'),
          body: Text(
            'All content, features, and functionality in Chatapp are the exclusive property of Chatapp and are protected by international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.',
          ),
        ),
        4.verticalSpaceFromWidth,
        const TermsOfServiceContent(
          title: Text('5. Privacy Policy'),
          body: Text(
            'Please refer to our Privacy Policy for information on how we collect, use, and disclose personal information.',
          ),
        ),
        4.verticalSpaceFromWidth,
        const TermsOfServiceContent(
          title: Text('6. Limitation of Liability'),
          body: Text(
            'Chatapp and its affiliates shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly.',
          ),
        ),
        4.verticalSpaceFromWidth,
        const TermsOfServiceContent(
          title: Text('7. Changes to Terms'),
          body: Text(
            'Chatapp and its affiliates shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly.',
          ),
        ),
        4.verticalSpaceFromWidth,
        const TermsOfServiceContent(
          title: Text('8. Governing Law'),
          body: Text(
            'These Terms are governed by and construed in accordance with the laws of Indonesia, without regard to its conflict of law principles.',
          ),
        ),
        24.verticalSpaceFromWidth,
        Text(
          'Privacy Policy',
          style: AppTypography.heading2,
        ),
        const Divider(),
        const TermsOfServiceContent(
          title: Text('1. Information We Collect'),
          body: Text(
            'Chatapp collects and stores information you provide, including but not limited to your Google Account details, profile information, and chat history.',
          ),
        ),
        4.verticalSpaceFromWidth,
        const TermsOfServiceContent(
          title: Text('2. How We Use Your Information'),
          body: Text(
            'We use the collected information to provide, maintain, and improve Chatapp, as well as to enhance user experience and communicate with you.',
          ),
        ),
        4.verticalSpaceFromWidth,
        const TermsOfServiceContent(
          title: Text('3. Sharing of Information'),
          body: Text(
            'We do not share your personal information with third parties except as outlined in this Privacy Policy or with your consent.',
          ),
        ),
        4.verticalSpaceFromWidth,
        const TermsOfServiceContent(
          title: Text('4. Security'),
          body: Text(
            'We implement reasonable security measures to protect the security of your information. However, we cannot guarantee the complete security of your information.',
          ),
        ),
        4.verticalSpaceFromWidth,
        const TermsOfServiceContent(
          title: Text('5. User Rights'),
          body: Text(
            'You have the right to access, correct, or delete your personal information. Please contact us at yudistriawan@gmail.com for any such requests.',
          ),
        ),
        4.verticalSpaceFromWidth,
        const TermsOfServiceContent(
          title: Text('6. Changes to Privacy Policy'),
          body: Text(
            'We may update our Privacy Policy from time to time. You will be notified of any changes by posting the new Privacy Policy on this page.',
          ),
        ),
        4.verticalSpaceFromWidth,
        const TermsOfServiceContent(
          title: Text('7. Contact Information'),
          body: Text(
            'If you have any questions or concerns about our Terms of Service or Privacy Policy, please contact us at yudistriawan@gmail.com.',
          ),
        ),
      ],
    );
  }
}

class TermsOfServiceContent extends StatelessWidget {
  const TermsOfServiceContent({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  final Widget title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    Widget title = this.title;
    Widget body = this.body;

    if (title is Text) {
      title = Text(
        title.data ?? '',
        key: title.key,
        style: title.style ?? AppTypography.bodyText1.bold,
      );
    }

    if (body is Text) {
      body = ClickableLinkWidget(
        body.data ?? '',
        key: body.key,
        style: body.style ?? AppTypography.metadata1,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        2.verticalSpace,
        body,
      ],
    );
  }
}
