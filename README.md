# EA2Latex

EA2Latex enhances Enterprise Architect with advanced document generaration features to support the model driven specification work flow. EA2Latex generates ready to release specification documents from your EA model which require no further tweaking.

EA2Latex was started as an internal tool at [DSPECIALISTS](http://www.dspecialists.com) and has been presented at the Embedded World Conference 2016 in Nuremberg where it received public interest. In the cause DSPECIALISTS decided to release EA2Latex to the public.

## Architecture

EA2Latex uses a client/server architecture with the following basic component:s
 * EA2Latex Addin: The Enterprise Architect extension module
 * Build Server: Server based LaTeX Build-Environment which is triggered by the Addin to complete document generation.

The server based approach has been chosen to easily provide all members of a team with the same build environment and to reduce the need of client updates.

Communication between Addin and Server is realized using SSH and SFTP.

## Documentation

All current documentation is written in German language but will be translated to English in the near future. As for now Google translate does a decent job for those who can't wait for the translation.

See [EA2Latex_Handbuch.pdf](Documentation/EA2Latex_Handbuch/EA2Latex_Handbuch.pdf) for the latest User Manual.

## Getting Started

 1. Download the EA2Latex Addin and install it onto your Enterprise Architect PC
 2. Setup a Build Server, e.g. by setting up a Linux server or virtual machine containing:
  * a LaTeX distribution (e.g. texlive)
  * [RTF2Latex](https://sourceforge.net/projects/rtf2latex2e/)
  * sshd
  * smbd
 3. Create a user (e.g. "ealatex") on the build machine which will execute the build script
 4. Use [PuTTY](https://the.earth.li/~sgtatham/putty/latest/x86/putty.exe) to connect to the Build Server via SSH and accept the server key.
 5. Download the [default EA2Latex specification template](EA2Latex/Templates_tex/Default_Spec) and copy it onto the Build Server, e.g. into /home/ealatex/ealatex_bin
 6. Configure the EA2Latex Addin
  1. Fire up Enterprise Architect and open a project. 
  2. Right-click on a package in the Project Browser and choose "Extensions/EA2Latex/Manage" from the context menu. 
  3. EA2Latex Addin will complain about a missing configuration file and will offer you to open the configuration folder.
  4. Hit [Yes] to open the configuratino folder.
  5. Rename the existing ea2latex_default.conf to ea2latex.conf.
  6. Edit the ea2latex.conf file to reflect your Build Server setup.
 7. Start building a document from a package in the Project Browser using the context menu "Extensions/EA2Latex/Generate"
  * EA2Latex will ask you for your Build Server login credentials
  * NOTE: It is important that you have accepted the server key beforehand as described above.

See the [user manual](Documentation/EA2Latex_Handbuch/EA2Latex_Handbuch.pdf) for further details.

Additional Notes:
 * The ea2latex.conf file contains the target_path entry which describes an absolute path on the Build Server where document files will be generated, e.g. /home/ealatex/ea2latex_docs
 * The samba setup on the Build Server should reflect to share that directory so that it can be accessed from outside as in \\build-server\home\ealatex\ea2latex_docs.

## Downloads

See the Releases section of the repository for binary downloads.
