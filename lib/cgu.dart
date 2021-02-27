import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class CGUPage extends Page {
  CGUPage() : super(key: ValueKey("cgu"));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return CGUScreen();
      },
    );
  }
}

class CGUScreen extends StatefulWidget {
  @override
  _CGUScreenState createState() => _CGUScreenState();
}

class _CGUScreenState extends State<CGUScreen> with TickerProviderStateMixin {
  TabController _tabController;
  TabBar tabBar;
  AppBar appBar;
  @override
  void initState() {
    appBar = AppBar(
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
    );

    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    tabBar = new TabBar(
      indicatorColor: Colors.transparent,
      labelColor: Colors.grey,
      labelStyle: TextStyle(fontSize: 20),
      controller: _tabController,
      tabs: [
        Tab(icon: Text('Privacy Policy')),
        Tab(icon: Text('Terms of Service')),
      ],
    );

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < 414;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appBar,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromARGB(255, 0, 0, 0),
                Color.fromARGB(255, 0, 6, 61)
              ])),
          child: Column(
            children: [
              Container(width: !isMobile ? 600 : null, child: tabBar),
              Container(
                color: Colors.black12,
                height: MediaQuery.of(context).size.height -
                    (tabBar.preferredSize.height + appBar.preferredSize.height),
                width: !isMobile ? 600 : null,
                child: new TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Html(data: _privacy, style: _style),
                    )),
                    SingleChildScrollView(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Html(data: _terms, style: _style),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

var _style = {
  // text that renders h1 elements will be red
  "*": Style(color: Colors.white70),
};

String _privacy = """
<h2>Privacy Policy</h2>
<p>Your privacy is important to us. It is TAJAOUART Mounir&#39;s policy to respect your privacy and comply with any applicable law and regulation regarding any personal information we may collect about you, including across our website, <a href="https://www.tajaouart.com">https://www.tajaouart.com</a>, and other sites we own and operate. </p>
<p>This policy is effective as of 26 February 2021 and was last updated on 26 February 2021. </p>
<h3>Information We Collect</h3>
<p>Information we collect includes both information you knowingly and actively provide us when using or participating in any of our services and promotions, and any information automatically sent by your devices in the course of accessing our products and services. </p>
<h4>Log Data</h4>
<p>When you visit our website, our servers may automatically log the standard data provided by your web browser. It may include your device’s Internet Protocol (IP) address, your browser type and version, the pages you visit, the time and date of your visit, the time spent on each page, other details about your visit, and technical details that occur in conjunction with any errors you may encounter. </p>
<p>Please be aware that while this information may not be personally identifying by itself, it may be possible to combine it with other data to personally identify individual persons. </p>
<h4>Personal Information</h4>
<p>We may ask for personal information which may include one or more of the following: </p>
<ul>
<li>Name</li>
<li>Email</li>
</ul>
<h4>Legitimate Reasons for Processing Your Personal Information</h4>
<p>We only collect and use your personal information when we have a legitimate reason for doing so. In which instance, we only collect personal information that is reasonably necessary to provide our services to you. </p>
<h4>Collection and Use of Information</h4>
<p>We may collect personal information from you when you do any of the following on our website: </p>
<ul>
<li>Use a mobile device or web browser to access our content</li>
<li>Contact us via email, social media, or on any similar technologies</li>
<li>When you mention us on social media</li>
</ul>
<p>We may collect, hold, use, and disclose information for the following purposes, and personal information will not be further processed in a manner that is incompatible with these purposes: </p>
<p>Please be aware that we may combine information we collect about you with general information or research data we receive from other trusted sources. </p>
<h4>Security of Your Personal Information</h4>
<p>When we collect and process personal information, and while we retain this information, we will protect it within commercially acceptable means to prevent loss and theft, as well as unauthorised access, disclosure, copying, use, or modification. </p>
<p>Although we will do our best to protect the personal information you provide to us, we advise that no method of electronic transmission or storage is 100% secure, and no one can guarantee absolute data security. We will comply with laws applicable to us in respect of any data breach. </p>
<p>You are responsible for selecting any password and its overall security strength, ensuring the security of your own information within the bounds of our services. </p>
<h4>How Long We Keep Your Personal Information</h4>
<p>We keep your personal information only for as long as we need to. This time period may depend on what we are using your information for, in accordance with this privacy policy. If your personal information is no longer required, we will delete it or make it anonymous by removing all details that identify you. </p>
<p>However, if necessary, we may retain your personal information for our compliance with a legal, accounting, or reporting obligation or for archiving purposes in the public interest, scientific, or historical research purposes or statistical purposes. </p>
<h3>Children’s Privacy</h3>
<p>We do not aim any of our products or services directly at children under the age of 13, and we do not knowingly collect personal information about children under 13. </p>
<h3>International Transfers of Personal Information</h3>
<p>The personal information we collect is stored and/or processed where we or our partners, affiliates, and third-party providers maintain facilities. Please be aware that the locations to which we store, process, or transfer your personal information may not have the same data protection laws as the country in which you initially provided the information. If we transfer your personal information to third parties in other countries: (i) we will perform those transfers in accordance with the requirements of applicable law; and (ii) we will protect the transferred personal information in accordance with this privacy policy. </p>
<h3>Your Rights and Controlling Your Personal Information</h3>
<p>You always retain the right to withhold personal information from us, with the understanding that your experience of our website may be affected. We will not discriminate against you for exercising any of your rights over your personal information. If you do provide us with personal information you understand that we will collect, hold, use and disclose it in accordance with this privacy policy. You retain the right to request details of any personal information we hold about you. </p>
<p>If we receive personal information about you from a third party, we will protect it as set out in this privacy policy. If you are a third party providing personal information about somebody else, you represent and warrant that you have such person’s consent to provide the personal information to us. </p>
<p>If you have previously agreed to us using your personal information for direct marketing purposes, you may change your mind at any time. We will provide you with the ability to unsubscribe from our email-database or opt out of communications. Please be aware we may need to request specific information from you to help us confirm your identity. </p>
<p>If you believe that any information we hold about you is inaccurate, out of date, incomplete, irrelevant, or misleading, please contact us using the details provided in this privacy policy. We will take reasonable steps to correct any information found to be inaccurate, incomplete, misleading, or out of date. </p>
<p>If you believe that we have breached a relevant data protection law and wish to make a complaint, please contact us using the details below and provide us with full details of the alleged breach. We will promptly investigate your complaint and respond to you, in writing, setting out the outcome of our investigation and the steps we will take to deal with your complaint. You also have the right to contact a regulatory body or data protection authority in relation to your complaint. </p>
<h3>Limits of Our Policy</h3>
<p>Our website may link to external sites that are not operated by us. Please be aware that we have no control over the content and policies of those sites, and cannot accept responsibility or liability for their respective privacy practices. </p>
<h3>Changes to This Policy</h3>
<p>At our discretion, we may change our privacy policy to reflect updates to our business processes, current acceptable practices, or legislative or regulatory changes. If we decide to change this privacy policy, we will post the changes here at the same link by which you are accessing this privacy policy. </p>
<p>If required by law, we will get your permission or give you the opportunity to opt in to or opt out of, as applicable, any new uses of your personal information. </p>
<h3>Contact Us</h3>
<p>For any questions or concerns regarding your privacy, you may contact us using the following details: </p>
<p>tajamnr@gmail.com<br />
https://www.tajaouart.com </p>
""";

String _terms = """
<h2>Terms of Service</h2>
<p>These Terms of Service govern your use of the website located at <a href="https://www.tajaouart.com">https://www.tajaouart.com</a> and any related services provided by TAJAOUART Mounir. </p>
<p>By accessing <a href="https://www.tajaouart.com">https://www.tajaouart.com</a>, you agree to abide by these Terms of Service and to comply with all applicable laws and regulations. If you do not agree with these Terms of Service, you are prohibited from using or accessing this website or using any other services provided by TAJAOUART Mounir. </p>
<p>We, TAJAOUART Mounir, reserve the right to review and amend any of these Terms of Service at our sole discretion. Upon doing so, we will update this page. Any changes to these Terms of Service will take effect immediately from the date of publication. </p>
<p>These Terms of Service were last updated on 26 February 2021. </p>
<h3>Limitations of Use</h3>
<p>By using this website, you warrant on behalf of yourself, your users, and other parties you represent that you will not: </p>
<ol>
   <li>modify, copy, prepare derivative works of, decompile, or reverse engineer any materials and software contained on this website;</li>
   <li>remove any copyright or other proprietary notations from any materials and software on this website;</li>
   <li>transfer the materials to another person or “mirror” the materials on any other server;</li>
   <li>knowingly or negligently use this website or any of its associated services in a way that abuses or disrupts our networks or any other service TAJAOUART Mounir provides;</li>
   <li>use this website or its associated services to transmit or publish any harassing, indecent, obscene, fraudulent, or unlawful material;</li>
   <li>use this website or its associated services in violation of any applicable laws or regulations;</li>
   <li>use this website in conjunction with sending unauthorized advertising or spam;</li>
   <li>harvest, collect, or gather user data without the user’s consent; or</li>
   <li>use this website or its associated services in such a way that may infringe the privacy, intellectual property rights, or other rights of third parties.</li>
</ol>
<h3>Intellectual Property</h3>
<p>The intellectual property in the materials contained in this website are owned by or licensed to TAJAOUART Mounir and are protected by applicable copyright and trademark law. We grant our users permission to download one copy of the materials for personal, non-commercial transitory use. </p>
<p>This constitutes the grant of a license, not a transfer of title. This license shall automatically terminate if you violate any of these restrictions or the Terms of Service, and may be terminated by TAJAOUART Mounir at any time. </p>
<h3>Liability</h3>
<p>Our website and the materials on our website are provided on an 'as is' basis. To the extent permitted by law, TAJAOUART Mounir makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property, or other violation of rights. </p>
<p>In no event shall TAJAOUART Mounir or its suppliers be liable for any consequential loss suffered or incurred by you or any third party arising from the use or inability to use this website or the materials on this website, even if TAJAOUART Mounir or an authorized representative has been notified, orally or in writing, of the possibility of such damage. </p>
<p>In the context of this agreement, &ldquo;consequential loss&rdquo; includes any consequential loss, indirect loss, real or anticipated loss of profit, loss of benefit, loss of revenue, loss of business, loss of goodwill, loss of opportunity, loss of savings, loss of reputation, loss of use and/or loss or corruption of data, whether under statute, contract, equity, tort (including negligence), indemnity, or otherwise. </p>
<p>Because some jurisdictions do not allow limitations on implied warranties, or limitations of liability for consequential or incidental damages, these limitations may not apply to you. </p>
<h3>Accuracy of Materials</h3>
<p>The materials appearing on our website are not comprehensive and are for general information purposes only. TAJAOUART Mounir does not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of the materials on this website, or otherwise relating to such materials or on any resources linked to this website. </p>
<h3>Links</h3>
<p>TAJAOUART Mounir has not reviewed all of the sites linked to its website and is not responsible for the contents of any such linked site. The inclusion of any link does not imply endorsement, approval, or control by TAJAOUART Mounir of the site. Use of any such linked site is at your own risk and we strongly advise you make your own investigations with respect to the suitability of those sites. </p>
<h3>Right to Terminate</h3>
<p>We may suspend or terminate your right to use our website and terminate these Terms of Service immediately upon written notice to you for any breach of these Terms of Service. </p>
<h3>Severance</h3>
<p>Any term of these Terms of Service which is wholly or partially void or unenforceable is severed to the extent that it is void or unenforceable. The validity of the remainder of these Terms of Service is not affected. </p>
<h3>Governing Law</h3>
<p>These Terms of Service are governed by and construed in accordance with the laws of France. You irrevocably submit to the exclusive jurisdiction of the courts in that State or location. </p>

""";
