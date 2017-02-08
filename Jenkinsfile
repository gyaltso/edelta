node {
   def mvnHome
   stage('Preparation') { // for display purposes
      checkout scm
      // Get the Maven tool.
      // ** NOTE: This 'M3' Maven tool must be configured
      // **       in the global configuration.           
      mvnHome = tool 'M3'
   }
   stage('Build') {
      wrap([$class: 'Xvfb', autoDisplayName: true]) {
        // Run the maven build
        sh "'${mvnHome}/bin/mvn' -f edelta.parent/pom.xml clean verify -Pjacoco"
      }
   }
   stage('Results') {
      junit '**/target/surefire-reports/TEST-*.xml'
      archive '**/target/repository/'
      publishHTML(target: [
        allowMissing: false,
        alwaysLinkToLastBuild: true,
        keepAll: true,
        reportDir: 'edelta.parent/edelta.tests.report/target/site/jacoco-aggregate',
        reportFiles: 'index.html',
        reportName: 'Jacoco HTML Report'
      ])
   }
   stage('Code Coverage') {
     step([$class: 'JacocoPublisher',
       execPattern: '**/**.exec',
       sourcePattern: '**/edelta/src,**/edelta.ui/src,**/edelta.lib/src',
       classPattern: '**/edelta/**/classes,**/edelta.lib/**/classes,**/edelta.ui/**/classes',
       exclusionPattern: '**/*Test*.class,**/edelta/edelta/**/*.class,**/antlr/**/*.class,**/serializer/*.class,**/*Abstract*RuntimeModule.class,**/*StandaloneSetup*.class,**/*Abstract*Validator.class,**/*GrammarAccess*.class,**/*Abstract*UiModule.class,**/*Abstract*ProposalProvider.class,**/internal/*.class,**/*NewProjectWizard.class,**/*ProjectCreator.class'])
   }
}