about_body = <<-HTML
<p>This is an experimental curriculum project designed to learn about how teachers can make effective use of well organized materials. We relied on ELA and math OER curriculum in grades 9–12 heavily for this pilot project. If you have any questions or feedback about the materials on this site, please contact us. We hope you enjoy using this site!</p>
HTML

Page.create_with(body: about_body, title: 'About').find_or_create_by(slug: 'about')
Page.create_with(body: about_body, title: 'Our People').find_or_create_by(slug: 'about_people')

pd_body = <<-HTML
Professional Development
HTML

Page.create_with(body: pd_body, title: 'Professional Development').find_or_create_by(slug: 'professional_development')

tos_body = <<-HTML
<p><em>Last updated:  May 12, 2016</em></p>

<p>&nbsp;</p>

<p>Please read these Terms of Service (&quot;Terms&quot;, &quot;Terms of Service&quot;) carefully before using the website (the &quot;Service&quot;) operated by UnboundEd (&quot;us&quot;, &quot;we&quot;, or &quot;our&quot;).</p>

<p>Your access to and use of the Service is conditioned on your acceptance of and compliance with these Terms. These Terms apply to all visitors, users and others who access or use the Service.&nbsp;By accessing or using the Service you agree to be bound by these Terms. If you disagree with any part of the terms then you may not access the Service.</p>

<h3>Relation to Service Agreement </h3>

<p>If you are a party that has entered into a Service Agreement with UnboundEd, you remain bound by the terms of your Service Agreement.  If the terms of your Service Agreement conflict with any of these Terms, the terms of your Service Agreement shall control.</p>

<h3>Permissible Use; Copyright</h3>

<p>Except where explicitly specified, documents and materials published on StandardsInstitutes.org are available under a Creative Commons Attribution-Non-Commercial-ShareAlike license (<a data-jsb_prepared="0h9x2x0nb2" href="https://creativecommons.org/licenses/by-nc-sa/3.0/" rel="noreferrer">https://creativecommons.org/licenses/by-nc-sa/3.0/</a>). They may be used without fee for personal, private, and educational purposes only.&nbsp; For-profit reproduction or commercial use is prohibited.&nbsp;You must give appropriate attribution to the author of any document and materials and provide a link to the Creative Common Attribution-Non-Commercial-ShareALike license.</p>

<p>Permission to copy, use, and distribute materials as described above shall not extend to information housed on StandardsInstitutes.org that is credited to other sources, or to information on websites to which this site links.</p>

<h3>Uploaded User Content</h3>

<p>We are not responsible for any content (&quot;User Content&quot;) that you or any one besides UnboundEd posts to our website.  You are solely responsible for your User Content, if any.  We do not endorse or approve any User Content and you may not and you may not state or imply that your User Content is in any way provided, sponsored or endorsed by UnboundEd. We respect the intellectual property rights of others. You must have the legal right to upload any User Content to the Services. You may not upload or post any User Content to the Services that infringes the copyright, trademark or other intellectual property rights of a third party nor may you upload User Content that violates any third party's right of privacy or right of publicity. You may upload only User Content that you are permitted to upload by the owner or by law. By submitting User Content to the site, you represent and warrant that you own the rights to the User Content or are otherwise authorized to post, distribute, display, perform, transmit such User Content. Because you alone are responsible for your User Content (and not UnboundEd), you may expose yourself to liability if, for example, your User Content violates the Rules of Conduct.  We are not obligated to backup any User Content and you are solely responsible for creating backup copies of your User Content.</p>

<p>In addition, in keeping with our goal of providing free Open Education Resources (OER) to the widest possible audience, we require that when necessary all submitted User Content be licensed in a way that it is freely reusable by anyone who cares to access it from our web site.
In addition, by submitting User Content to the UnboundEd site, you hereby grant the UnboundEd a worldwide, perpetual, non-exclusive, royalty-free, sublicenseable, transferable and non-terminable license to use, reproduce, distribute, prepare derivative works of, display, and perform the User Content in connection with the Service and the Standard Institute&rsquo;s (and its successors&#39; and affiliates&#39;)  business, including without limitation for promoting and redistributing part or all of the Service (and derivative works thereof) in any media formats and through any media channels. You also hereby grant each user of the Service a non-exclusive license to access your User Content through the Service, and to use, reproduce, distribute, display and perform such Content as permitted through the functionality of the Service and under these Terms of Service.</p>

<h3>Removal of User Content</h3>

<p>We reserve the right (but are not obligated) to remove, block, edit, move or disable User Content that is objectionable to us for any reason.  The decision to remove User Content or other Content is in our sole and final discretion.  To the maximum extent permitted by law, we do no assume any responsibility or liability for User Content.  You are solely responsible for your User Content and may be held liable for User Content that you post to our site.</p>

<h3>User Behavior</h3>

<p>These terms are forthcoming pending the addition of further user features.</p>

<h3>Privacy Policy</h3>

<p>If you chose to use the Service, we will collect, use, share and disclose your information as described in our Privacy Policy set forth below.  If you do not wish to share your information in accordance with our Privacy Policy, please do not use the Service.</p>

<h3>Automated Systems and Indexing</h3>

<p>You agree not to use or launch any automated system, including without limitation, &quot;robots,&quot; &quot;spiders,&quot; or &quot;offline readers,&quot; that accesses the Service in a manner that sends more request messages to the UnboundEd servers in a given period of time than a human can reasonably produce in the same period by using a conventional on-line web browser. Notwithstanding the foregoing, UnboundEd grants the operators of public search engines permission to use spiders to copy materials from the site for the sole purpose of and solely to the extent necessary for creating publicly available searchable indices of the materials, but not caches or archives of such materials. UnboundEd reserves the right to revoke these exceptions either generally or in specific cases. You agree not to collect or harvest any personally identifiable information, including account names, from the Service, nor to use the communication systems provided by the Service (e.g., comments, email) for any commercial solicitation purposes. You agree not to solicit, for commercial purposes, any users of the Service with respect to their Content.</p>

<h3>Digital Millennium Copyright Act Notice</h3>

<p>If you are a copyright owner or an agent thereof and believe that any Content infringes upon your copyrights, you may submit a notification pursuant to the Digital Millennium Copyright Act (&quot;DMCA&quot;) by providing our Copyright Agent with the following information in writing (see 17 U.S.C 512(c)(3) for further detail):</p>

<ul>
 <li>A physical or electronic signature of a person authorized to act on behalf of the owner of an exclusive right that is allegedly infringed;</li>
 <li>Identification of the copyrighted work claimed to have been infringed, or, if multiple copyrighted works at a single online site are covered by a single notification, a representative list of such works at that site;</li>
 <li>Identification of the material that is claimed to be infringing or to be the subject of infringing activity and that is to be removed or access to which is to be disabled and information reasonably sufficient to permit the service provider to locate the material;</li>
 <li>Information reasonably sufficient to permit the service provider to contact you, such as an address, telephone number, and, if available, an electronic mail;</li>
 <li>A statement that you have a good faith belief that use of the material in the manner complained of is not authorized by the copyright owner, its agent, or the law; and</li>
 <li>A statement that the information in the notification is accurate, and under penalty of perjury, that you are authorized to act on behalf of the owner of an exclusive right that is allegedly infringed.</li>
</ul>

<p>You may direct copyright infringement notifications to our DMCA Agent at:</p>

<p>Copyright Agent</p>

<p>c/o The Achievement Network Ltd</p>

<p>225 Friend Street</p>

<p>Boston, MA&nbsp; 02114</p>

<p>Counter-Notice. If you believe that your Content that was removed (or to which access was disabled) is not infringing, or that you have the authorization from the copyright owner, the copyright owner&39;s agent, or pursuant to the law, to post and use the material in your Content, you may send a counter-notice containing the following information to the Copyright Agent:</p>

<ul>
 <li>Your physical or electronic signature;</li>
 <li>Identification of the Content that has been removed or to which access has been disabled and the location at which the Content appeared before it was removed or disabled;</li>
 <li>A statement that you have a good faith belief that the Content was removed or disabled as a result of mistake or a misidentification of the Content; and</li>
 <li>Your name, address, telephone number, and e-mail address, a statement that you consent to the jurisdiction of the federal court in Boston, Massachusetts, and a statement that you will accept service of process from the person who provided notification of the alleged infringement.</li>
</ul>

<p>If a counter-notice is received by the Copyright Agent, UnboundEd may send a copy of the counter-notice to the original complaining party informing that person that it may replace the removed Content or cease disabling it in 10 business days. Unless the copyright owner files an action seeking a court order against the Content provider, member or user, the removed Content may be replaced, or access to it restored, in 10 to 14 business days or more after receipt of the counter-notice, at the UnboundEd&rsquo;s sole discretion.</p>

<h3>Links To Other Web Sites</h3>

<p>Our site may contain links to third-party web sites or services that are not owned or controlled by UnboundEd.</p>

<p>We have not reviewed, and cannot review, all of the material, including computer software, made available through the websites and webpages to which UnboundEd.org links, and that link to UnboundEd.org. We dos not have any control over those websites and webpages, and are not responsible for their contents or their use. By linking to a website or webpage, we do not represent or imply that we endorse such website, webpage or content. You are responsible for taking precautions as necessary to protect yourself and your computer systems from viruses, worms, Trojan horses, and other harmful or destructive content. We disclaim any responsibility for any harm resulting from your use of linked websites and webpages.</p>

<p>We strongly advise you to read the terms and conditions and privacy policies of any third-party web sites or services that you visit.</p>

<h3>Governing Law</h3>

<p>These Terms shall be governed and construed in accordance with the laws of the Commonwealth of Massachusetts, United States, without regard to its conflict of law provisions.</p>

<p>Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights. If any provision of these Terms is held to be invalid or unenforceable by a court, the remaining provisions of these Terms will remain in effect. These Terms constitute the entire agreement between us regarding our Service, and supersede and replace any prior agreements we might have between us regarding the Service.</p>

<h3>Warranty Disclaimer</h3>

<p>WE PROVIDE THE SERVICE &quot;AS IS&quot; AND &quot;AS AVAILABLE&quot;.  YOU AGREE THAT YOUR USE OF THE SERVICES SHALL BE AT YOUR SOLE RISK. TO THE FULLEST EXTENT PERMITTED BY LAW, UNBOUNDED, ITS OFFICERS, DIRECTORS, EMPLOYEES, AND AGENTS DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, IN CONNECTION WITH THE SERVICES AND YOUR USE THEREOF. UNBOUNDED MAKES NO WARRANTIES OR REPRESENTATIONS ABOUT THE ACCURACY OR COMPLETENESS OF THIS SITE&#39;S CONTENT OR THE CONTENT OF ANY SITES LINKED TO THIS SITE AND ASSUMES NO LIABILITY OR RESPONSIBILITY FOR ANYTHING RELATED TO THE SITE INCLUDING WITHOUT LIMITATION (I) ERRORS, MISTAKES, OR INACCURACIES OF CONTENT, (II) PERSONAL INJURY OR PROPERTY DAMAGE, OF ANY NATURE WHATSOEVER, RESULTING FROM YOUR ACCESS TO AND USE OF OUR SERVICES, (III) ANY UNAUTHORIZED ACCESS TO OR USE OF OUR SECURE SERVERS AND/OR ANY AND ALL PERSONAL INFORMATION AND/OR FINANCIAL INFORMATION STORED THEREIN, (IV) ANY INTERRUPTION OR CESSATION OF TRANSMISSION TO OR FROM OUR SERVICES, (V) ANY BUGS, VIRUSES, TROJAN HORSES, OR THE LIKE WHICH MAY BE TRANSMITTED TO OR THROUGH OUR SERVICES BY ANY THIRD PARTY, AND/OR (VI) ANY ERRORS OR OMISSIONS IN ANY CONTENT OR FOR ANY LOSS OR DAMAGE OF ANY KIND INCURRED AS A RESULT OF THE USE OF ANY CONTENT POSTED, EMAILED, TRANSMITTED, OR OTHERWISE MADE AVAILABLE VIA THE SERVICES. UNBOUNDED DOES NOT WARRANT, ENDORSE, GUARANTEE, OR ASSUME RESPONSIBILITY FOR ANY PRODUCT OR SERVICE ADVERTISED OR OFFERED BY A THIRD PARTY THROUGH THE SERVICES OR ANY HYPERLINKED SERVICES OR FEATURED IN ANY BANNER OR OTHER ADVERTISING, AND UNBOUNDED WILL NOT BE A PARTY TO OR IN ANY WAY BE RESPONSIBLE FOR MONITORING ANY TRANSACTION BETWEEN YOU AND THIRD-PARTY PROVIDERS OF PRODUCTS OR SERVICES. AS WITH THE PURCHASE OF A PRODUCT OR SERVICE THROUGH ANY MEDIUM OR IN ANY ENVIRONMENT, YOU SHOULD USE YOUR BEST JUDGMENT AND EXERCISE CAUTION WHERE APPROPRIATE.</p>

<p>YOU AGREE AND ACKNOWLEDGE THAT THE LIMITATIONS AND EXCLUSIONS OF LIABILITIY AND WARRANTY PROVIDED IN THESE TERMS ARE FAIR AND REASONABLE.</p>

<h3>Limitation of Liability</h3>

<p>TO THE MAXIMUM EXTENT PERMITTED BY LAW, UNBOUNDED, ITS OWNERS, OFFICERS, DIRECTORS, EMPLOYEES, OR AGENTS, SHALL NOT BE LIABLE TO YOU FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, PUNITIVE, EXEMPLARY OR CONSEQUENTIAL DAMAGES WHATSOEVER THAT MAY BE INCURRED BY YOU RESULTING FROM USE OF THE SERVICE HOWEVER CAUSED AND UNDER ANY THEORY OF LIAIBITY ARISING OUT OF OR RELATED TO YOUR USE OF THE SERVICES OR THESE TERMS.  THIS INCLUDES, BUT IS NOT LIMITED TO, ANY LOSS OF PROFIT (WHETHER INCURRED DIRECTLY OR INDIRECTLY), ANY LOSS OF GOODWILL OR REPUTATION, ANY OF LOSS OF DATA, COST TO PROCURE SUBSTITUTE GOODS OR SERVICES OR OTHER INTANGIBLE LOSS OR ANY LOSS OR DAMAGE THAT MAY BE INCURRED BY YOUR AS A RESULT OF ANY CHANGES THAT WE MAY MAKE TO THE SERVICE, ANY PERMANENT OR TEMPORARY CESSATION OF SERVICES OR ANY FEATURES, THE DELETION OF OR FAILURE TO STORE ANY CONTENT OR USER CONTENT OR YOUR FAILURE TO KEEP YOUR PASSWORD OR ACCOUNT DETAILS SECURE AND CONFIDENTIAL.</p>

<p>YOU SPECIFICALLY ACKNOWLEDGE THAT UNBOUNDED SHALL NOT BE LIABLE FOR CONTENT OR THE DEFAMATORY, OFFENSIVE, OR ILLEGAL CONDUCT OF ANY THIRD PARTY AND THAT THE RISK OF HARM OR DAMAGE FROM THE FOREGOING RESTS ENTIRELY WITH YOU.</p>

<p>YOU ACKNOWLEDGE AND AGREE THAT YOUR SOLE AND EXCLUSIVE REMEDY FOR ANY DISPUTE WITH UNBOUNDED, ITS OWNERS, OFFICERS, DIRECTORS, EMPLOYEES, AGENTS AND AFFILIATIES ARISING OUT OF OR RELATING TO THE SERVICE OR ANY OF OUR CONTENT IS TO STOP USING THE SERVICE.  YOU ACKNOWLEDGE AND AGREE THAT UNBOUNDED, ITS OWNERS, OFFICERS, DIRECTORS, EMPLOYEES, AGENTS AND AFFILIATIES ARE NOT LIABLE FOR ANY ACT OR FAILURE TO ACT BY THEM OR ANY OTHER PERSON REGARDING CONDUCT, COMMUNICATION OR CONTENT ON THE SERVICE.  IN NO CASE SHALL THE LIABILITY OF UNBOUNDED, OWNERS, OFFICERS, DIRECTORS, EMPLOYEES, AGENTS AND AFFILIATIES TO YOU EXCEED THE AMOUNT YOU PAID TO US FOR THE SERVICE.</p>

<p>BECAUSE SOME STATES DO NOT ALLOW THE EXCLUSION OR THE LIMITATION OF LIABILTY FOR CONSEQUENTIAL, INDIRECT, EXEMPLARY, SPECIAL, PUNITIVE OR INCIDENTAL DAMAGES, IN SUCH STATES, THE LIABILTY OF UNBOUNDED, ITS OWNERS, OFFICERS, DIRECTORS, EMPLOYEES, AGENTS AND AFFILIATIES SHALL BE LIMITED TO THE FULL EXTENT PERMITTED BY SUCH APPLICABLE LAW.</p>

<p>The Service is controlled and offered by UnboundEd from its facilities in the United States of America. UnboundEd makes no representations that the Service is appropriate or available for use in other locations. Those who access or use the Service from other jurisdictions do so at their own volition and are responsible for compliance with local law.</p>

<h3>Indemnity</h3>

<p>To the extent permitted by applicable law, you agree to defend, indemnify and hold harmless UnboundEd, its parent corporation, officers, directors, employees and agents, from and against any and all claims, damages, obligations, losses, liabilities, costs or debt, and expenses (including but not limited to attorney&#39;s fees) arising from: (i) your use or misuse of and access to the Service; (ii) your violation of any of these Terms; (iii) your violation of any third party right, including without limitation any copyright, property, or privacy right; or (iv) any claim that your User Content caused damage to a third party. This defense and indemnification obligation will survive these Terms and your use of the Service.</p>

<h3>Changes to Service and Terms of Service</h3>

<p>We update the Service frequently. You agree that UnboundEd can make changes, additions, substitutions and reductions to the Service without notice to you and that we are not liable to you for any such changes. Additionally, we reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material we will try to provide at least 30 days notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.</p>

<p>By continuing to access or use our Service after those revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, please stop using the Service.</p>

<h3>Termination of the Service</h3>

<p>We reserve the right to stop providing the Service to you at any time and for any reason without prior notice.</p>

<h3>Entire Agreement; Notice; Waiver; Severability</h3>

<p>These Terms constitute the entire legal agreement between UnboundEd and you and completely replace any prior agreements between you and us in relation to the Services.  You agree that we may provide you with notices, including those regarding changes to these Terms, by email, regular mail, or postings on the website.  Our failure to exercise or enforce any right or provision in these Terms will not constitute a waiver of any such right or provision.  Any waiver of any provision of these Terms will be effective only if in a writing signed by us.  If any part of these Terms is held invalid or unenforceable, that portion shall be interpreted in a manner consistent with applicable law to reflect, as nearly as possible, the original intentions of UnboundEd and the remaining portions shall remain in full force and effect.</p>

<h3>Third Party Beneficiaries</h3>

<p>You agree that these Terms are not intended to confer and do not confer any rights or remedies upon any person other than the parties to these Terms.</p>

<h3>Contact Us</h3>

<p>If you have any questions about these Terms, please contact us at support AT unbounded.org.</p>
HTML

Page.create_with(body: tos_body, title: 'Terms of Service').find_or_create_by(slug: 'tos')


privacy_body = <<-HTML
<p><em>Last modified: May 12, 2016</em></p>

<p>&nbsp;</p>

<h3>SUMMARY</h3>

<p>We will treat your data carefully, preserving your privacy according to the rules laid out in this document, and to the best of our ability.</p>

<p>As you use our services, we want you to be clear how we’re using information and the ways in which you can protect your privacy and use our services. Our Privacy Policy explains: What information we collect and why we collect it, and how we use that information.</p>

<h3>WHAT INFORMATION WE COLLECT AND WHY WE COLLECT IT</h3>

<p>We collect information to provide better services to all of our users. We collect information in two ways:</p>

<h4>Information you give us</h4>

<p>For example, in the future, some of our services may require you to sign up for an Account. When you do, we’ll ask for personal information, like your name, email address, and a password.</p>

<h4>Information we get from your use of our services</h4>

<p>We may collect information about the services that you use and how you use them, like when you visit a website that uses our services or you view and interact with our technology via a browser plug­in. This information includes:</p>

<h4>Credential information</h4>

<p>We may obtain and compare your provided login credentials with known credentials associated with your account in order to provide you access with your account. We may store and issue temporary credentials on your behalf for purposes such as password resets.</p>

<h4>Device information</h4>

<p>We may collect device specific information (such as your hardware model, operating system version, unique device identifiers, and mobile network information including phone number). We may associate your device identifiers or phone number with your Account.</p>

<h4>Log and application information</h4>

<p>When you use our services or view content, we may automatically collect and store certain information in server logs. This may include: details of how you used our service, such as your activities on authorized websites, Internet protocol address, device event information such as crashes, system activity, hardware settings, browser type, browser language, the date and time of your request and referral URL, cookies that may uniquely identify your browser or your Account.</p>

<h4>Network information</h4>

<p>When you use our service, we may collect and process information about your network, such as your IP address, your Internet Service Provider, your domain name, your bandwidth, your network route to the Internet and to our services.</p>

<h4>Location information</h4>

<p>When you use a location enabled service, we may collect and process information about your actual location. When you do not use a location enabled service, we may infer your approximate location by examining your Network information.</p>

<h4>Local storage</h4>

<p>We may collect and store information (including personal information) locally on your device using mechanisms such as browser web storage (including HTML 5) and application data caches.</p>

<h4>Cookies and anonymous identifiers</h4>

<p>We use various technologies to collect and store information when you visit our service, and this may include sending one or more cookies or anonymous identifiers to your device.</p>

<h4>Links and Integrations</h4>

<p>Our site contains links and integrations with third party sites whose information and privacy collection policies may be different from our own. This privacy policy does not apply to third party sites. Please consult the relevant polices from such third parties to learn more about their information gathering policies.</p>

<h3>HOW WE USE INFORMATION WE COLLECT</h3>

<p>We use the information we collect from all of our services first and foremost to provide information to our customers and partners to help them provide services based on the information. We also use the information to provide, maintain, protect and improve the services we offer as well as to develop new services, to keep our system running effectively and to protect our system and our users.</p>

<p>We will never sell information provided by, or about, you to our customers or partners or anyone else.</p>

<p>We may share information about our users with partners for purposes of delivering our services. For example, we might share information about specific users to a data analytics partner who can analyze this information to provide predictions about the services a user might need (this is sometimes called &quot;predictive analytics&quot; or &quot;collaborative filtering&quot;). In cases where we do share information in this way to partners, we will ensure that the partner is bound by the same or similar privacy agreement as this one, so that your information cannot be used by that organization in a way that is different from how we use it, as described in this privacy policy.</p>

<p>When you contact us, we may keep a record of your communication to help solve any issues you might be facing. We may use your email address to inform you about our services, such as letting you know about upcoming changes or improvements, or in the case of urgent updates.</p>

<p>We use information collected from cookies and other technologies, like pixel tags and web page events, to improve your user experience and the overall quality of our services.</p>

<p>We will ask for your consent before using information for a purpose other than those that are set out in this Privacy Policy. We currently processes personal information on servers located in the United States. When we process your personal information, we do not guarantee it will be on a server located in the country where you live. Our management of your data will always be governed by this Privacy Policy.</p>

<h3>TRANSPARENCY AND CHOICE</h3>

<p>People have different privacy concerns. Our goal is to be clear about what information we collect, so that you can make meaningful choices about how it is used.</p>

<p>We always aim to maintain our services in a manner that protects information from accidental disclosure or malicious interference. Because of this, after you delete information from our services, we may not immediately delete residual copies from our active servers and may not remove information from our backup systems, but we will still follow this Privacy Policy when managing those residual copies.</p>

<h3>INFORMATION WE SHARE</h3>

<p>We do not share personal information with companies, organizations or individuals outside of our organization unless one of the following circumstances applies:</p>

<h4>With your consent</h4>

<p>We will share personal information with companies, organizations or individuals outside of our organization when we have your consent to do so. We require opt­in consent for the sharing of any sensitive personal information.</p>

<h4>For external processing</h4>

<p>We provide personal information to our affiliates or other trusted businesses or persons to process it for us, based on our instructions and in compliance with our Privacy Policy and any other appropriate regulations, confidentiality and security measures.</p>

<h4>For legal reasons</h4>

<p>We will share personal information with companies, organizations or individuals outside of our organization if we have a good faith belief that access, use, preservation or disclosure of the information is reasonably necessary to: meet any applicable law, regulation, legal process or enforceable governmental request, enforce applicable Terms of Service, including investigation of potential violations, detect, prevent, or otherwise address fraud, security or technical issues, protect against harm to the rights, property or safety of our organization, our users, employees or the public as required or permitted by law.</p>

<p>We may share aggregated, non­personally identifiable information with our partners for purposes of improving our services. For example, we may share information about the usage of our site with our management, customers, funders and other parties, provided that none of such information will include personally identifiable information. If we are involved in a merger, acquisition or asset sale, we will continue to ensure the confidentiality of any personal information and give affected users notice before personal information is transferred or becomes subject to a different privacy policy.</p>

<h4>For Disseminating Information About Our Services</h4>

<p>We may use the information collected to send you information and opportunities related to Standards Institute.  If you would like to opt-out of these communications, please send an email to support AT unbounded.org.</p>

<h3>INFORMATION SECURITY</h3>

<p>We work hard to protect our organization and our users from unauthorized access to or unauthorized alteration, disclosure or destruction of information we hold. In particular, we encrypt many of our services using SSL. We review our information collection, storage and processing practices, including physical security measures, to guard against unauthorized access to systems. We restrict access to personal information to employees, contractors and agents who need to know that information in order to process or manage it for us, and who are subject to strict contractual confidentiality obligations and may be disciplined or terminated if they fail to meet these obligations.</p>

<h3>WHEN THIS PRIVACY POLICY APPLIES</h3>

<p>Our Privacy Policy applies to all of the services offered by us and our affiliates, including services offered on other sites (such as our partners) where the data from those services are managed by our organization, but excludes services that have separate privacy policies that do not incorporate this Privacy Policy. Our Privacy Policy does not apply to services offered by other companies or individuals, including products or sites that may include our services, or other sites linked to from our services. Our Privacy Policy does not cover the information practices of other companies and organizations who advertise our services, and who may use cookies, pixel tags and other technologies to serve and offer relevant, complementary or related services.</p>

<h3>COMPLIANCE AND COOPERATION WITH REGULATORY AUTHORITIES</h3>

<p>We regularly review our compliance with our Privacy Policy. We also adhere to several selfregulatory frameworks. When we receive formal written complaints, we will contact the person who made the complaint to follow up. We work with the appropriate regulatory authorities, including local data protection authorities, to resolve any complaints regarding the transfer of personal data that we cannot resolve with our users directly.</p>

<h3>PRIVACY OF CHILDREN</h3>

<p>Our site operates in compliance with the Children&#39;s Online Privacy Protection Act (COPPA). We never knowingly collect information from children under the age of 13 and no part of our website aims to serve or attract children under the age of 13. Visitors under 13 are strictly prohibited from using the website at any point for any reason.</p>

<h3>SECURITY</h3>

<p>We work hard to keep private data secure. Although we cannot guarantee the security of information, we have implemented a number of best practices in physical, electronic, and managerial security practices in order to prevent unauthorized access to private data. For example, when a user provides a password, that information is stored in an encrypted manner. We also use Secure Socket Layer (SSL) for portions of our Sites to transfer data securely.  You can check whether SSL is active by looking for a &quot;locked&quot; padlock icon within your browser. Please be aware, however, that despite our efforts, no security measures are perfect.</p>

<p>If you use a password to access the website, you are responsible for keeping the password private and confidential. You must refrain from sharing it with other people. If you suspect your password has been misused in any way, please notify us at support AT unbounded.org.</p>

<h3>CHANGES</h3>

<p>Our Privacy Policy may change from time to time. We will not reduce your rights under this Privacy Policy without your explicit consent or giving you the opportunity to opt­out of any changes. Opting­out could require stopping your use of our services entirely.</p>

<p>We will post any privacy policy changes on this page and, if the changes are significant, we will provide a more prominent notice (including, for certain services, email notification of privacy policy changes). Significant changes will be effective 30 days following our posting of the change to our website or the date we email you about such changes.  All other changes are effective on the day we post the change to our website.  Any change to how we use your personal information is considered a significant change.  If you do not wish to permit changes in our use of your personal information, you must notify us prior to the effective date of the change. Continued use of our services following notice of changes shall indicate your acknowledgement of such changes and agreement to be bound by the terms and conditions of such change.</p>

<p>If you have questions regarding our privacy policy or if you want to report any security violations to us, you can email us at support AT unbounded.org.</p>


<p><em>Last Revised: May 12, 2016</em></p>
HTML

Page.create_with(body: privacy_body, title: 'UnboundEd Privacy Policy').find_or_create_by(slug: 'privacy')
