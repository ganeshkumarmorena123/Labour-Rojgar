import 'package:flutter/material.dart';

void main() => runApp(const LabourRojgarApp());

class AppJob {
  AppJob({required this.id, required this.title, required this.category, required this.pay, required this.location, required this.days, required this.workers, required this.description, required this.postedBy});
  final int id;
  final String title, category, pay, location, days, workers, description, postedBy;
}

class Application {
  Application({required this.jobId, required this.status});
  final int jobId;
  String status;
}

class LabourRojgarApp extends StatefulWidget {
  const LabourRojgarApp({super.key});
  @override State<LabourRojgarApp> createState() => _LabourRojgarAppState();
}

class _LabourRojgarAppState extends State<LabourRojgarApp> {
  String? role;
  bool loggedIn = false;
  String name = '';
  String phone = '';
  int tab = 0;
  final List<Application> applications = [];
  final List<AppJob> jobs = [
    AppJob(id: 1, title: 'राजमिस्त्री की जरूरत', category: 'राजमिस्त्री', pay: '₹900 / दिन', location: 'भोपाल', days: '5 दिन', workers: '2', description: 'घर निर्माण के लिए अनुभवी राजमिस्त्री चाहिए। सुबह 8 बजे से शाम 6 बजे तक काम।', postedBy: 'रमेश जी'),
    AppJob(id: 2, title: 'पेंटर की जरूरत', category: 'पेंटर', pay: '₹700 / दिन', location: 'भोपाल', days: '3 दिन', workers: '3', description: 'घर की अंदरूनी पेंटिंग के लिए पेंटर चाहिए।', postedBy: 'सुरेश जी'),
    AppJob(id: 3, title: 'निर्माण मजदूर चाहिए', category: 'मजदूर', pay: '₹650 / दिन', location: 'इंदौर', days: '7 दिन', workers: '5', description: 'निर्माण स्थल पर सामान्य मजदूरी का काम।', postedBy: 'अजय कंस्ट्रक्शन'),
    AppJob(id: 4, title: 'टाइल मिस्त्री चाहिए', category: 'टाइल मिस्त्री', pay: '₹1000 / दिन', location: 'उज्जैन', days: '10 दिन', workers: '1', description: 'फर्श और बाथरूम टाइल लगाने का काम।', postedBy: 'विनोद जी'),
  ];

  void login(String selectedRole, String userName, String userPhone) {
    setState(() { role = selectedRole; name = userName; phone = userPhone; loggedIn = true; tab = 0; });
  }

  void logout() => setState(() { loggedIn = false; role = null; name = ''; phone = ''; tab = 0; });

  void addJob(AppJob job) => setState(() => jobs.insert(0, job));

  @override Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Labour Rojgar',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF146C43), scaffoldBackgroundColor: const Color(0xFFF7F9F7), inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(), filled: true, fillColor: Colors.white)),
      home: loggedIn ? MainShell(role: role!, name: name, phone: phone, jobs: jobs, applications: applications, onApply: (id) { if (!applications.any((a) => a.jobId == id)) setState(() => applications.add(Application(jobId: id, status: 'Pending'))); }, onAddJob: addJob, onLogout: logout) : LoginFlow(onLogin: login),
    );
  }
}

class LoginFlow extends StatefulWidget {
  const LoginFlow({super.key, required this.onLogin});
  final void Function(String role, String name, String phone) onLogin;
  @override State<LoginFlow> createState() => _LoginFlowState();
}
class _LoginFlowState extends State<LoginFlow> {
  String? selectedRole;
  final name = TextEditingController();
  final phone = TextEditingController();
  final otp = TextEditingController();
  bool otpSent = false;
  @override void dispose() { name.dispose(); phone.dispose(); otp.dispose(); super.dispose(); }
  void sendOtp() { if (phone.text.trim().length != 10) { snack(context, 'कृपया 10 अंकों का मोबाइल नंबर डालें'); return; } setState(() => otpSent = true); snack(context, 'Demo OTP: 123456'); }
  void verify() { if (name.text.trim().isEmpty) { snack(context, 'नाम दर्ज करें'); return; } if (otp.text.trim() != '123456') { snack(context, 'Demo में OTP 123456 डालें'); return; } widget.onLogin(selectedRole!, name.text.trim(), phone.text.trim()); }
  @override Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 520), child: Column(children: [
      const SizedBox(height: 20),
      Container(width: 88, height: 88, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(24)), child: const Icon(Icons.handshake, size: 52, color: Colors.white)),
      const SizedBox(height: 18), const Text('Labour Rojgar', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)), const SizedBox(height: 6), const Text('काम मिले आसान, रोजगार बने सम्मान', textAlign: TextAlign.center), const SizedBox(height: 30),
      const Align(alignment: Alignment.centerLeft, child: Text('आप कौन हैं?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))), const SizedBox(height: 12),
      Row(children: [roleCard('मजदूर', Icons.construction, 'worker'), const SizedBox(width: 12), roleCard('काम देने वाला', Icons.business_center, 'employer')]),
      const SizedBox(height: 20),
      if (selectedRole != null) ...[
        TextField(controller: name, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'पूरा नाम', prefixIcon: Icon(Icons.person))), const SizedBox(height: 12),
        TextField(controller: phone, keyboardType: TextInputType.phone, maxLength: 10, decoration: const InputDecoration(labelText: 'मोबाइल नंबर', prefixIcon: Icon(Icons.phone), counterText: '')),
        const SizedBox(height: 12),
        if (!otpSent) FilledButton.icon(onPressed: sendOtp, icon: const Icon(Icons.sms), label: const SizedBox(width: double.infinity, child: Center(child: Padding(padding: EdgeInsets.all(15), child: Text('OTP भेजें')))))
        else ...[
          TextField(controller: otp, keyboardType: TextInputType.number, maxLength: 6, decoration: const InputDecoration(labelText: 'OTP डालें', prefixIcon: Icon(Icons.lock), counterText: '')),
          FilledButton.icon(onPressed: verify, icon: const Icon(Icons.login), label: const SizedBox(width: double.infinity, child: Center(child: Padding(padding: EdgeInsets.all(15), child: Text('Login / Register'))))),
        ],
      ],
      const SizedBox(height: 18), const Text('Demo version • OTP: 123456', style: TextStyle(color: Colors.grey)),
    ])))));
  }
  Widget roleCard(String label, IconData icon, String value) => Expanded(child: InkWell(onTap: () => setState(() => selectedRole = value), borderRadius: BorderRadius.circular(16), child: Card(color: selectedRole == value ? Theme.of(context).colorScheme.primaryContainer : null, child: Padding(padding: const EdgeInsets.symmetric(vertical: 22), child: Column(children: [Icon(icon, size: 38), const SizedBox(height: 8), Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))])))));
}

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.role, required this.name, required this.phone, required this.jobs, required this.applications, required this.onApply, required this.onAddJob, required this.onLogout});
  final String role, name, phone; final List<AppJob> jobs; final List<Application> applications; final void Function(int) onApply; final void Function(AppJob) onAddJob; final VoidCallback onLogout;
  @override State<MainShell> createState() => _MainShellState();
}
class _MainShellState extends State<MainShell> {
  int tab = 0;
  @override Widget build(BuildContext context) {
    final worker = widget.role == 'worker';
    final pages = worker ? [WorkerHome(widget: widget, goJobs: () => setState(() => tab = 1)), JobsPage(widget: widget), ApplicationsPage(widget: widget), ProfilePage(name: widget.name, phone: widget.phone, role: widget.role, onLogout: widget.onLogout)] : [EmployerHome(widget: widget, goPost: () => setState(() => tab = 1)), PostJobPage(widget: widget), MyJobsPage(widget: widget), ProfilePage(name: widget.name, phone: widget.phone, role: widget.role, onLogout: widget.onLogout)];
    final labels = worker ? ['Home', 'काम', 'Applications', 'Profile'] : ['Home', 'काम पोस्ट', 'मेरे काम', 'Profile'];
    final icons = worker ? [Icons.home, Icons.work, Icons.assignment, Icons.person] : [Icons.home, Icons.add_business, Icons.list_alt, Icons.person];
    return Scaffold(appBar: AppBar(title: const Text('Labour Rojgar'), actions: [IconButton(onPressed: () => showAboutDialog(context: context, applicationName: 'Labour Rojgar', applicationVersion: '1.0.0 MVP', children: const [Text('मजदूर और काम देने वालों को जोड़ने वाला प्लेटफॉर्म।')]), icon: const Icon(Icons.info_outline))]), body: pages[tab], bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (i) => setState(() => tab = i), destinations: List.generate(labels.length, (i) => NavigationDestination(icon: Icon(icons[i]), label: labels[i]))));
  }
}

class WorkerHome extends StatelessWidget { const WorkerHome({super.key, required this.widget, required this.goJobs}); final MainShell widget; final VoidCallback goJobs; @override Widget build(BuildContext c) => ListView(padding: const EdgeInsets.all(16), children: [greeting(widget.name, 'आज आपके लिए काम ढूंढते हैं'), const SizedBox(height: 16), Row(children: [statCard(c, 'उपलब्ध काम', '${widget.jobs.length}', Icons.work), const SizedBox(width: 10), statCard(c, 'Applications', '${widget.applications.length}', Icons.assignment)]), const SizedBox(height: 18), sectionTitle('आपके आसपास के काम'), ...widget.jobs.take(3).map((j) => jobCard(c, j, widget, compact: true)), const SizedBox(height: 10), OutlinedButton.icon(onPressed: goJobs, icon: const Icon(Icons.search), label: const Text('सभी काम देखें'))]); }
class EmployerHome extends StatelessWidget { const EmployerHome({super.key, required this.widget, required this.goPost}); final MainShell widget; final VoidCallback goPost; @override Widget build(BuildContext c) => ListView(padding: const EdgeInsets.all(16), children: [greeting(widget.name, 'आज जल्दी मजदूर खोजें'), const SizedBox(height: 16), Row(children: [statCard(c, 'मेरे पोस्ट', '${widget.jobs.where((j) => j.postedBy == widget.name).length}', Icons.post_add), const SizedBox(width: 10), statCard(c, 'कुल jobs', '${widget.jobs.length}', Icons.work_history)]), const SizedBox(height: 22), Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.add_business, size: 42), const SizedBox(height: 10), const Text('नया काम पोस्ट करें', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 6), const Text('काम की जगह, मजदूरी और जरूरत के मजदूरों की जानकारी दें।'), const SizedBox(height: 15), FilledButton.icon(onPressed: goPost, icon: const Icon(Icons.add), label: const Text('काम पोस्ट करें'))]))), const SizedBox(height: 18), sectionTitle('हाल के काम'), ...widget.jobs.take(3).map((j) => jobCard(c, j, widget, compact: true))]); }

class JobsPage extends StatefulWidget { const JobsPage({super.key, required this.widget}); final MainShell widget; @override State<JobsPage> createState() => _JobsPageState(); }
class _JobsPageState extends State<JobsPage> { String q = ''; String category = 'सभी'; @override Widget build(BuildContext c) { final cats = ['सभी', ...{...widget.widget.jobs.map((j) => j.category)}]; final filtered = widget.widget.jobs.where((j) => (category == 'सभी' || j.category == category) && (q.isEmpty || '${j.title} ${j.location} ${j.category}'.toLowerCase().contains(q.toLowerCase()))).toList(); return Column(children: [Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), child: TextField(onChanged: (v) => setState(() => q = v), decoration: const InputDecoration(hintText: 'काम या जगह खोजें', prefixIcon: Icon(Icons.search)))), SizedBox(height: 48, child: ListView.separated(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: cats.length, separatorBuilder: (_, __) => const SizedBox(width: 8), itemBuilder: (_, i) => ChoiceChip(label: Text(cats[i]), selected: category == cats[i], onSelected: (_) => setState(() => category = cats[i])))), Expanded(child: filtered.isEmpty ? const Center(child: Text('कोई काम नहीं मिला')) : ListView.builder(padding: const EdgeInsets.all(12), itemCount: filtered.length, itemBuilder: (_, i) => jobCard(c, filtered[i], widget.widget)))]); } }

class ApplicationsPage extends StatelessWidget { const ApplicationsPage({super.key, required this.widget}); final MainShell widget; @override Widget build(BuildContext c) => widget.applications.isEmpty ? emptyState('अभी कोई application नहीं है', Icons.assignment) : ListView(padding: const EdgeInsets.all(12), children: widget.applications.map((a) { final j = widget.jobs.firstWhere((x) => x.id == a.jobId); return Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.work)), title: Text(j.title), subtitle: Text('${j.location} • ${j.pay}'), trailing: Chip(label: Text(a.status))); }).toList()); }

class PostJobPage extends StatefulWidget { const PostJobPage({super.key, required this.widget}); final MainShell widget; @override State<PostJobPage> createState() => _PostJobPageState(); }
class _PostJobPageState extends State<PostJobPage> { final title=TextEditingController(), category=TextEditingController(), pay=TextEditingController(), location=TextEditingController(), days=TextEditingController(), workers=TextEditingController(), desc=TextEditingController(); @override void dispose(){for(final x in [title,category,pay,location,days,workers,desc])x.dispose();super.dispose();} void submit(){if([title,category,pay,location,days,workers].any((x)=>x.text.trim().isEmpty)){snack(context,'सभी जरूरी जानकारी भरें');return;} widget.widget.onAddJob(AppJob(id: DateTime.now().millisecondsSinceEpoch, title:title.text, category:category.text, pay:'₹${pay.text} / दिन', location:location.text, days:'${days.text} दिन', workers:workers.text, description:desc.text.isEmpty?'काम की जानकारी उपलब्ध नहीं है।':desc.text, postedBy:widget.widget.name)); for(final x in [title,category,pay,location,days,workers,desc])x.clear(); snack(context,'काम सफलतापूर्वक पोस्ट हो गया');} @override Widget build(BuildContext c)=>ListView(padding:const EdgeInsets.all(16),children:[formField(title,'काम का नाम','जैसे राजमिस्त्री चाहिए'),formField(category,'काम की category','जैसे राजमिस्त्री'),formField(pay,'दिहाड़ी (₹)','जैसे 900',number:true),formField(location,'काम की जगह','शहर/गांव'),formField(days,'कितने दिन','जैसे 5',number:true),formField(workers,'कितने मजदूर','जैसे 2',number:true),formField(desc,'काम का विवरण','काम का समय, अनुभव आदि',lines:4),const SizedBox(height:8),FilledButton.icon(onPressed:submit,icon:const Icon(Icons.publish),label:const Padding(padding:EdgeInsets.all(14),child:Text('काम पोस्ट करें'))]); }

class MyJobsPage extends StatelessWidget { const MyJobsPage({super.key, required this.widget}); final MainShell widget; @override Widget build(BuildContext c){final mine=widget.jobs.where((j)=>j.postedBy==widget.name).toList(); return mine.isEmpty?emptyState('आपने अभी कोई काम पोस्ट नहीं किया',Icons.post_add):ListView(padding:const EdgeInsets.all(12),children:mine.map((j)=>Card(child:ListTile(title:Text(j.title),subtitle:Text('${j.location} • ${j.pay} • ${j.workers} मजदूर'),trailing:const Icon(Icons.chevron_right),onTap:()=>showJobDetails(c,j,widget))).toList());} }

class ProfilePage extends StatelessWidget { const ProfilePage({super.key, required this.name, required this.phone, required this.role, required this.onLogout}); final String name,phone,role; final VoidCallback onLogout; @override Widget build(BuildContext c)=>ListView(padding:const EdgeInsets.all(16),children:[Center(child:CircleAvatar(radius:45,child:Text(name.isEmpty?'U':name[0].toUpperCase(),style:const TextStyle(fontSize:34)))),const SizedBox(height:12),Center(child:Text(name,style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold))),Center(child:Text(phone)),const SizedBox(height:24),Card(child:Column(children:[ListTile(leading:const Icon(Icons.badge),title:const Text('भूमिका'),subtitle:Text(role=='worker'?'मजदूर':'काम देने वाला')),const Divider(height:1),const ListTile(leading:Icon(Icons.verified_user),title:Text('खाता'),subtitle:Text('Demo verified account'))])),const SizedBox(height:16),OutlinedButton.icon(onPressed:()=>showDialog(context:c,builder:(_)=>AlertDialog(title:const Text('Logout करें?'),content:const Text('आपको फिर से Login करना होगा।'),actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('नहीं')),FilledButton(onPressed:(){Navigator.pop(c);onLogout();},child:const Text('Logout'))])),icon:const Icon(Icons.logout),label:const Text('Logout'))]); }

Widget jobCard(BuildContext c, AppJob j, MainShell w, {bool compact=false}) => Card(margin:const EdgeInsets.only(bottom:10), child: InkWell(borderRadius:BorderRadius.circular(12),onTap:()=>showJobDetails(c,j,w),child:Padding(padding:const EdgeInsets.all(14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[const CircleAvatar(child:Icon(Icons.work)),const SizedBox(width:12),Expanded(child:Text(j.title,style:const TextStyle(fontWeight:FontWeight.bold,fontSize:16))),Text(j.pay,style:const TextStyle(fontWeight:FontWeight.bold))]),const SizedBox(height:10),Wrap(spacing:12,runSpacing:6,children:[info(Icons.location_on,j.location),info(Icons.calendar_month,j.days),info(Icons.people,'${j.workers} मजदूर')]),if(!compact)...[const SizedBox(height:10),Text(j.description,maxLines:2,overflow:TextOverflow.ellipsis),const SizedBox(height:10),Align(alignment:Alignment.centerRight,child:FilledButton(onPressed:()=>showJobDetails(c,j,w),child:const Text('विवरण देखें')))] ]))));

void showJobDetails(BuildContext c, AppJob j, MainShell w){final applied=w.applications.any((a)=>a.jobId==j.id);showModalBottomSheet(context:c,isScrollControlled:true,showDragHandle:true,builder:(_)=>Padding(padding:const EdgeInsets.fromLTRB(20,0,20,30),child:SingleChildScrollView(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(j.title,style:const TextStyle(fontSize:24,fontWeight:FontWeight.bold)),const SizedBox(height:10),Text(j.pay,style:TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:Theme.of(c).colorScheme.primary)),const SizedBox(height:14),infoRow(Icons.location_on,'स्थान',j.location),infoRow(Icons.calendar_month,'अवधि',j.days),infoRow(Icons.people,'जरूरत', '${j.workers} मजदूर'),infoRow(Icons.person,'पोस्ट करने वाला',j.postedBy),const Divider(height:30),const Text('काम का विवरण',style:TextStyle(fontWeight:FontWeight.bold,fontSize:17)),const SizedBox(height:6),Text(j.description),const SizedBox(height:20),if(w.role=='worker')SizedBox(width:double.infinity,child:FilledButton.icon(onPressed:applied?null:(){w.onApply(j.id);Navigator.pop(c);snack(c,'Application सफलतापूर्वक भेज दी गई');},icon:Icon(applied?Icons.check:Icons.send),label:Text(applied?'Applied':'काम के लिए Apply करें')))])));}

Widget greeting(String name,String sub)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('नमस्ते, $name 👋',style:const TextStyle(fontSize:24,fontWeight:FontWeight.bold)),const SizedBox(height:4),Text(sub)]);
Widget statCard(BuildContext c,String title,String value,IconData icon)=>Expanded(child:Card(child:Padding(padding:const EdgeInsets.all(16),child:Row(children:[Icon(icon,size:30),const SizedBox(width:12),Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(value,style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)),Text(title)])]))));
Widget sectionTitle(String t)=>Padding(padding:const EdgeInsets.only(bottom:10),child:Text(t,style:const TextStyle(fontSize:19,fontWeight:FontWeight.bold)));
Widget info(IconData i,String t)=>Row(mainAxisSize:MainAxisSize.min,children:[Icon(i,size:17),const SizedBox(width:4),Text(t)]);
Widget infoRow(IconData i,String a,String b)=>Padding(padding:const EdgeInsets.only(bottom:12),child:Row(children:[Icon(i,size:21),const SizedBox(width:10),Text('$a: ',style:const TextStyle(fontWeight:FontWeight.bold)),Expanded(child:Text(b))]));
Widget formField(TextEditingController x,String label,String hint,{bool number=false,int lines=1})=>Padding(padding:const EdgeInsets.only(bottom:12),child:TextField(controller:x,keyboardType:number?TextInputType.number:TextInputType.text,maxLines:lines,decoration:InputDecoration(labelText:label,hintText:hint)));
Widget emptyState(String text,IconData icon)=>Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(icon,size:64,color:Colors.grey),const SizedBox(height:12),Text(text)]));
void snack(BuildContext c,String s)=>ScaffoldMessenger.of(c).showSnackBar(SnackBar(content:Text(s)));
