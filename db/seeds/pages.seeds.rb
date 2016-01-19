include Content::Models

about_body = <<-HTML
<p>This is an experimental curriculum project designed to learn about how teachers can make effective use of well organized materials. We relied on ELA and math OER curriculum in grades 9–12 heavily for this pilot project. If you have any questions or feedback about the materials on this site, please contact us. We hope you enjoy using this site!</p>
HTML

Page.create_with(body: about_body, title: 'About').find_or_create_by(slug: 'about')

pd_body = <<-HTML
Professional Development
HTML

Page.create_with(body: pd_body, title: 'Professional Development').find_or_create_by(slug: 'professional_development')

tos_body = <<-HTML
<p><em>Last updated: July 10, 2015</em></p>

<p>&nbsp;</p>

<p>Please read these Terms of Service (&quot;Terms&quot;, &quot;Terms of Service&quot;) carefully before using the website (the &quot;Service&quot;) operated by Standards Institute (&quot;us&quot;, &quot;we&quot;, or &quot;our&quot;).</p>

<p>Your access to and use of the Service is conditioned on your acceptance of and compliance with these Terms. These Terms apply to all visitors, users and others who access or use the Service.</p>

<p>By accessing or using the Service you agree to be bound by these Terms. If you disagree with any part of the terms then you may not access the Service.</p>

<h3>Relation to Service Agreement</h3>

<p>If you are a party that has entered into a Service Agreement with Standards Institutes, you remain bound by the terms of your Service Agreement.&nbsp; If the terms of your Service Agreement conflict with any of these Terms, the terms of your Service Agreement shall control.</p>

<h3>Permissible Use; Copyright</h3>

<p>Except where explicitly specified, documents and materials published on StandardsInstitutes.org are available under a Creative Commons Attribution-Non-Commercial-ShareAlike license (<a data-jsb_prepared="0h9x2x0nb2" href="https://creativecommons.org/licenses/by-nc-sa/3.0/" rel="noreferrer">https://creativecommons.org/licenses/by-nc-sa/3.0/</a>). They may be used without fee for personal, private, and educational purposes only.&nbsp; For-profit reproduction or commercial use is prohibited.&nbsp;You must give appropriate attribution to the author of any document and materials and provide a link to the Creative Common Attribution-Non-Commercial-ShareALike license.</p>

<p>Permission to copy, use, and distribute materials as described above shall not extend to information housed on StandardsInstitutes.org that is credited to other sources, or to information on websites to which this site links.</p>

<h3>Uploaded User Content</h3>

<p>We are not responsible for any content (&ldquo;User Content&rdquo;) that you or any one besides Standards Institute posts to our website.&nbsp; You are solely responsible for your User Content, if any.&nbsp; We do not endorse or approve any User Content and you may not &nbsp;and you may not state or imply that your User Content is in any way provided, sponsored or endorsed by Standards Institute. &nbsp;We respect the intellectual property rights of others. You must have the legal right to upload any User Content to the Services. You may not upload or post any User Content to the Services that infringes the copyright, trademark or other intellectual property rights of a third party nor may you upload User Content that violates any third party&#39;s right of privacy or right of publicity. You may upload only User Content that you are permitted to upload by the owner or by law. By submitting User Content to the site, you represent and warrant that you own the rights to the User Content or are otherwise authorized to post, distribute, display, perform, transmit such User Content. Because you alone are responsible for your User Content (and not Standards Institute), you may expose yourself to liability if, for example, your User Content violates the Rules of Conduct. &nbsp;We are not obligated to backup any User Content and you are solely responsible for creating backup copies of your User Content.</p>

<p>In addition, in keeping with our goal of providing free Open Education Resources (OER) to the widest possible audience, we require that when necessary all submitted User Content be licensed in a way that it is freely reusable by anyone who cares to access it from our web site.</p>

<p>In addition, by submitting User Content to the Standards Institute site, you hereby grant the Standards Institute a worldwide, perpetual, non-exclusive, royalty-free, sublicenseable, transferable and non-terminable license to use, reproduce, distribute, prepare derivative works of, display, and perform the User Content in connection with the Service and the Standard Institute&rsquo;s (and its successors&#39; and affiliates&#39;) business, including without limitation for promoting and redistributing part or all of the Service (and derivative works thereof) in any media formats and through any media channels. You also hereby grant each user of the Service a non-exclusive license to access your User Content through the Service, and to use, reproduce, distribute, display and perform such Content as permitted through the functionality of the Service and under these Terms of Service.. [DG1]&nbsp;</p>

<h3>Removal of User Content</h3>

<p>We reserve the right (but are not obligated) to remove, block, edit, move or disable User Content that is objectionable to us for any reason.&nbsp; The decision to remove User Content or other Content is in our sole and final discretion.&nbsp; To the maximum extent permitted by law, we do no assume any responsibility or liability for User Content.&nbsp; You are solely responsible for your User Content and may be held liable for User Content that you post to our site.</p>

<h3>User Behavior</h3>

<p>These terms are forthcoming pending the addition of further user features.</p>

<h3>Privacy Policy</h3>

<p>If you chose to use the Service, we will collect, use, share and disclose your information as described in our Privacy Policy set forth below.&nbsp; If you do not wish to share your information in accordance with our Privacy Policy, please do not use the Service.</p>

<h3>Automated Systems and Indexing</h3>

<p>You agree not to use or launch any automated system, including without limitation, &quot;robots,&quot; &quot;spiders,&quot; or &quot;offline readers,&quot; that accesses the Service in a manner that sends more request messages to the Standards Institute servers in a given period of time than a human can reasonably produce in the same period by using a conventional on-line web browser. Notwithstanding the foregoing, the Standards Institute grants the operators of public search engines permission to use spiders to copy materials from the site for the sole purpose of and solely to the extent necessary for creating publicly available searchable indices of the materials, but not caches or archives of such materials. The Standards Institute reserves the right to revoke these exceptions either generally or in specific cases. You agree not to collect or harvest any personally identifiable information, including account names, from the Service, nor to use the communication systems provided by the Service (e.g., comments, email) for any commercial solicitation purposes. You agree not to solicit, for commercial purposes, any users of the Service with respect to their Content.</p>

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

<p>Counter-Notice. If you believe that your Content that was removed (or to which access was disabled) is not infringing, or that you have the authorization from the copyright owner, the copyright owner&#39;s agent, or pursuant to the law, to post and use the material in your Content, you may send a counter-notice containing the following information to the Copyright Agent:</p>

<ul>
  <li>Your physical or electronic signature;</li>
  <li>Identification of the Content that has been removed or to which access has been disabled and the location at which the Content appeared before it was removed or disabled;</li>
  <li>A statement that you have a good faith belief that the Content was removed or disabled as a result of mistake or a misidentification of the Content; and</li>
  <li>Your name, address, telephone number, and e-mail address, a statement that you consent to the jurisdiction of the federal court in Boston, Massachusetts, and a statement that you will accept service of process from the person who provided notification of the alleged infringement.</li>
</ul>

<p>If a counter-notice is received by the Copyright Agent, Standards Institute may send a copy of the counter-notice to the original complaining party informing that person that it may replace the removed Content or cease disabling it in 10 business days. Unless the copyright owner files an action seeking a court order against the Content provider, member or user, the removed Content may be replaced, or access to it restored, in 10 to 14 business days or more after receipt of the counter-notice, at the Standard Institute&rsquo;s sole discretion.</p>

<h3>Links To Other Web Sites</h3>

<p>Our site may contain links to third-party web sites or services that are not owned or controlled by Standards Institute.</p>

<p>We have not reviewed, and cannot review, all of the material, including computer software, made available through the websites and webpages to which StandardsInstitutes.org.links, and that link to StandardsInstitutes.org. We dos not have any control over those websites and webpages, and are not responsible for their contents or their use. By linking to a website or webpage, we do not represent or imply that we endorse such website, webpage or content. You are responsible for taking precautions as necessary to protect yourself and your computer systems from viruses, worms, Trojan horses, and other harmful or destructive content. We disclaim any responsibility for any harm resulting from your use of linked websites and webpages.</p>

<p>We strongly advise you to read the terms and conditions and privacy policies of any third-party web sites or services that you visit.</p>

<h3>Governing Law</h3>

<p>These Terms shall be governed and construed in accordance with the laws of the Commonwealth of Massachusetts, United States, without regard to its conflict of law provisions.</p>

<p>Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights. If any provision of these Terms is held to be invalid or unenforceable by a court, the remaining provisions of these Terms will remain in effect. These Terms constitute the entire agreement between us regarding our Service, and supersede and replace any prior agreements we might have between us regarding the Service.</p>

<h3>Warranty Disclaimer</h3>

<p>WE PROVIDE THE SERVICE &ldquo;AS IS&rdquo; AND &ldquo;AS AVAILABLE&rdquo;.&nbsp; YOU AGREE THAT YOUR USE OF THE SERVICES SHALL BE AT YOUR SOLE RISK. TO THE FULLEST EXTENT PERMITTED BY LAW, STANDARDS INSTITUTE, ITS OFFICERS, DIRECTORS, EMPLOYEES, AND AGENTS DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, IN CONNECTION WITH THE SERVICES AND YOUR USE THEREOF. STANDARDS INSTITUTE MAKES NO WARRANTIES OR REPRESENTATIONS ABOUT THE ACCURACY OR COMPLETENESS OF THIS SITE&#39;S CONTENT OR THE CONTENT OF ANY SITES LINKED TO THIS SITE AND ASSUMES NO LIABILITY OR RESPONSIBILITY FOR ANYTHING RELATED TO THE SITE INCLUDING WITHOUT LIMITATION (I) ERRORS, MISTAKES, OR INACCURACIES OF CONTENT, (II) PERSONAL INJURY OR PROPERTY DAMAGE, OF ANY NATURE WHATSOEVER, RESULTING FROM YOUR ACCESS TO AND USE OF OUR SERVICES, (III) ANY UNAUTHORIZED ACCESS TO OR USE OF OUR SECURE SERVERS AND/OR ANY AND ALL PERSONAL INFORMATION AND/OR FINANCIAL INFORMATION STORED THEREIN, (IV) ANY INTERRUPTION OR CESSATION OF TRANSMISSION TO OR FROM OUR SERVICES, (V) ANY BUGS, VIRUSES, TROJAN HORSES, OR THE LIKE WHICH MAY BE TRANSMITTED TO OR THROUGH OUR SERVICES BY ANY THIRD PARTY, AND/OR (VI) ANY ERRORS OR OMISSIONS IN ANY CONTENT OR FOR ANY LOSS OR DAMAGE OF ANY KIND INCURRED AS A RESULT OF THE USE OF ANY CONTENT POSTED, EMAILED, TRANSMITTED, OR OTHERWISE MADE AVAILABLE VIA THE SERVICES. STANDARDS INSTITUTE DOES NOT WARRANT, ENDORSE, GUARANTEE, OR ASSUME RESPONSIBILITY FOR ANY PRODUCT OR SERVICE ADVERTISED OR OFFERED BY A THIRD PARTY THROUGH THE SERVICES OR ANY HYPERLINKED SERVICES OR FEATURED IN ANY BANNER OR OTHER ADVERTISING, AND STANDARDS INSTITUTE WILL NOT BE A PARTY TO OR IN ANY WAY BE RESPONSIBLE FOR MONITORING ANY TRANSACTION BETWEEN YOU AND THIRD-PARTY PROVIDERS OF PRODUCTS OR SERVICES. AS WITH THE PURCHASE OF A PRODUCT OR SERVICE THROUGH ANY MEDIUM OR IN ANY ENVIRONMENT, YOU SHOULD USE YOUR BEST JUDGMENT AND EXERCISE CAUTION WHERE APPROPRIATE.</p>

<p>YOU AGREE AND ACKNOWLEDGE THAT THE LIMITATIONS AND EXCLUSIONS OF LIABILITIY AND WARRANTY PROVIDED IN THESE TERMS ARE FAIR AND REASONABLE.</p>

<h3>Limitation of Liability</h3>

<p>TO THE MAXIMUM&nbsp;EXTENT PERMITTED BY LAW, STANDARDS INSTITUTE, ITS OWNERS, OFFICERS, DIRECTORS, EMPLOYEES, OR AGENTS, SHALL NOT BE LIABLE TO YOU FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, PUNITIVE, EXEMPLARY OR CONSEQUENTIAL DAMAGES WHATSOEVER THAT MAY BE INCURRED BY YOU RESULTING FROM USE OF THE SERVICE HOWEVER CAUSED AND UNDER ANY THEORY OF LIAIBITY ARISING OUT OF OR RELATED TO YOUR USE OF THE SERVICES OR&nbsp;THESE TERMS.&nbsp; THIS INCLUDES, BUT IS NOT LIMITED TO, ANY LOSS OF PROFIT (WHETHER INCURRED DIRECTLY OR INDIRECTLY), ANY LOSS OF GOODWILL OR REPUTATION, ANY OF LOSS OF DATA, COST TO PROCURE SUBSTITUTE GOODS OR SERVICES OR OTHER INTANGIBLE LOSS OR ANY LOSS OR DAMAGE THAT MAY BE INCURRED BY YOUR AS A RESULT OF ANY CHANGES THAT WE MAY MAKE TO THE SERVICE, ANY PERMANENT OR TEMPORARY CESSATION OF SERVICES OR ANY FEATURES, THE DELETION OF OR FAILURE TO STORE ANY CONTENT OR USER CONTENT OR YOUR FAILURE TO KEEP YOUR PASSWORD OR ACCOUNT DETAILS SECURE AND CONFIDENTIAL.</p>

<p>YOU SPECIFICALLY ACKNOWLEDGE THAT STANDARDS INSTITUTE SHALL NOT BE LIABLE FOR CONTENT OR THE DEFAMATORY, OFFENSIVE, OR ILLEGAL CONDUCT OF ANY THIRD PARTY AND THAT THE RISK OF HARM OR DAMAGE FROM THE FOREGOING RESTS ENTIRELY WITH YOU.</p>

<p>YOU ACKNOWLEDGE AND AGREE THAT YOUR SOLE AND EXCLUSIVE REMEDY FOR ANY DISPUTE WITH STANDARDS INSTITUTE, ITS OWNERS, OFFICERS, DIRECTORS, EMPLOYEES, AGENTS AND AFFILIATIES ARISING OUT OF OR RELATING TO THE SERVICE OR ANY OF OUR CONTENT IS TO STOP USING THE SERVICE.&nbsp; YOU ACKNOWLEDGE AND AGREE THAT STANDARDS INSTITUTE, ITS OWNERS, OFFICERS, DIRECTORS, EMPLOYEES, AGENTS AND AFFILIATIES ARE NOT LIABLE FOR ANY ACT OR FAILURE TO ACT BY THEM OR ANY OTHER PERSON REGARDING CONDUCT, COMMUNICATION OR CONTENT ON THE SERVICE.&nbsp; IN NO CASE SHALL THE LIABILITY OF STANDARDS INSTITUTE, OWNERS, OFFICERS, DIRECTORS, EMPLOYEES, AGENTS AND AFFILIATIES TO YOU EXCEED THE AMOUNT YOU PAID TO US FOR THE SERVICE.</p>

<p>BECAUSE SOME STATES DO NOT ALLOW THE EXCLUSION OR THE LIMITATION OF LIABILTY FOR CONSEQUENTIAL, INDIRECT, EXEMPLARY, SPECIAL, PUNITIVE OR INCIDENTAL DAMAGES, IN SUCH STATES, THE LIABILTY OF STANDARDS INSTITUTE, ITS OWNERS, OFFICERS, DIRECTORS, EMPLOYEES, AGENTS AND AFFILIATIES SHALL BE LIMITED TO THE FULL EXTENT PERMITTED BY SUCH APPLICABLE LAW.</p>

<p>The Service is controlled and offered by Standards Institute from its facilities in the United States of America. Standards Institute makes no representations that the Service is appropriate or available for use in other locations. Those who access or use the Service from other jurisdictions do so at their own volition and are responsible for compliance with local law.</p>

<h3>Indemnity</h3>

<p>To the extent permitted by applicable law, you agree to defend, indemnify and hold harmless Standards Institute, its parent corporation, officers, directors, employees and agents, from and against any and all claims, damages, obligations, losses, liabilities, costs or debt, and expenses (including but not limited to attorney&#39;s fees) arising from: (i) your use or misuse of and access to the Service; (ii) your violation of any of these Terms; (iii) your violation of any third party right, including without limitation any copyright, property, or privacy right; or (iv) any claim that your User Content caused damage to a third party. This defense and indemnification obligation will survive these Terms and your use of the Service.</p>

<h3>Changes to Service and Terms of Service</h3>

<p>We update the Service frequently.&nbsp;You agree that Standards Institute can make changes, additions, substitutions and reductions to the Service without notice to you and that we are not liable to you for any such changes.&nbsp;Additionally, we reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material we will try to provide at least 30 days notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.</p>

<p>By continuing to access or use our Service after those revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, please stop using the Service.</p>

<h3>Termination of the Service</h3>

<p>We reserve the right to stop providing the Service to you at any time and for any reason without prior notice.</p>

<h3>Entire Agreement; Notice; Waiver; Severability</h3>

<p>These Terms constitute the entire legal agreement between Standards Institute and you and completely replace any prior agreements between you and us in relation to the Services.&nbsp; You agree that we may provide you with notices, including those regarding changes to these Terms, by email, regular mail, or postings on the website.&nbsp; Our failure to exercise or enforce any right or provision in these Terms will not constitute a waiver of any such right or provision.&nbsp; Any waiver of any provision of these Terms will be effective only if in a writing signed by us.&nbsp; If any part of these Terms is held invalid or unenforceable, that portion shall be interpreted in a manner consistent with applicable law to reflect, as nearly as possible, the original intentions of Standards Institute and the remaining portions shall remain in full force and effect.</p>

<h3>Third Party Beneficiaries</h3>

<p>You agree that these Terms are not intended to confer and do not confer any rights or remedies upon any person other than the parties to these Terms.</p>

<h3>Contact Us</h3>

<p>If you have any questions about these Terms, please contact us.</p>
HTML

Page.create_with(body: tos_body, title: 'Terms of Service').find_or_create_by(slug: 'tos')
