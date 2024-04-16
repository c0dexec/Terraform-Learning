***Note**: We are following the Part 3 of the [video](https://www.youtube.com/watch?v=7xngnjfIlK4&t=1712s).
# Terraform Architecture
![Terraform Architecture](files://C:\Users\Apoor\Documents\ShareX\Screenshots\2023-01\firefox_1HeFeqsQHo.png "Terraform Architecture")
+ We have our Terraform core which parses the configurations of our state files.
+ Providers are used to grab resources used by the core from the cloud provider.

# Commands
+ `terraform init` - Upon usage of the command, Terraform downloads the associtated provider specified within the `main.tf` from the Terraform registry.
    
    Before,
    ```console
    ➜  3 git:(main) ✗ tree -a .
    .
    ├── README.md
    └── main.tf

    0 directories, 2 files
    ```
    When the command gets executed,
    ```console
    ➜  3 git:(main) ✗ terraform init

    Initializing the backend...

    Initializing provider plugins...
    - Finding telmate/proxmox versions matching "2.9.11"...
    - Installing telmate/proxmox v2.9.11...
    - Installed telmate/proxmox v2.9.11 (self-signed, key ID A9EBBE091B35AFCE)

    Partner and community providers are signed by their developers.
    If you'd like to know more about provider signing, you can read about it here:
    https://www.terraform.io/docs/cli/plugins/signing.html

    Terraform has created a lock file .terraform.lock.hcl to record the provider
    selections it made above. Include this file in your version control repository
    so that Terraform can guarantee to make the same selections by default when
    you run "terraform init" in the future.

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
    ```
    And afterwards,
    ```console
    ➜  3 git:(main) ✗ tree -a
    .
    ├── .terraform
    │   └── providers
    │       └── registry.terraform.io
    │           └── telmate
    │               └── proxmox
    │                   └── 2.9.11
    │                       └── linux_amd64
    │                           ├── LICENSE
    │                           ├── README.md
    │                           └── terraform-provider-proxmox_v2.9.11
    ├── .terraform.lock.hcl
    ├── README.md
    └── main.tf

    7 directories, 6 files
    ```
    The lock file contains the hashes for the specific dependencise and providers being used within the workspace.

    If any modules were also being used then they also get pulled (within the `.terraform` sub directory).
    ![Modules Stored](C:\Users\Apoor\Documents\ShareX\Screenshots\2023-01\firefox_UQdaNYsVgK.png)
+ State File - A json type formatted file which contains information about every resource and data object that has been deployed. 
    - It can be stored remotely or locally (default). 
        - Local - Stored locally within the system
            - Simple to get staretd
            - Sensitive values stored as plain text
            - Uncollaborative as others cannot make changes to my state file (as its stored locally)
            - Manual (`terraform plan` and `terraform apply` needs to be ran often)
        - Remote - Stored in a remote location such as a Amazon Simple Storage Service(S3), Terraform cloud. Here is the [setup](https://youtu.be/7xngnjfIlK4?t=2561).
            - Encrypted senstive data and not stored on our system
            - Collaboration is possible with other engineers
            - Automation is possible
    - Also contains senstive information, such as passwords, db passwords, etc. So someways to protect a state file are,
        1. Have ACL for your state file.
        2. Have encryption for state file.
        3. Store is in a properly secured location.
+ `terraform plan` - Looks at the desired state (what we want our infrastructure to look like), our Terraform config. Then does a comparison with actual state of the world.
![terraform apply](C:\Users\Apoor\Documents\ShareX\Screenshots\2023-01\firefox_z3tY5mqM3Z.png)
In the diagram above when `terraform apply` is executed then Terraform perform a check against the "Actual State"(Current state of our cloud infrastructure). It notices that "network" infrastructure is already in place, so is the "database" but we have one less "server".
![terraform apply comparision](C:\Users\Apoor\Documents\ShareX\Screenshots\2023-01\firefox_YR3mP5bXEv.png)
So then initiates the command to create a VM instance.
**If `terraform destory` is executed right after it will destroy everything that is within our Actual state which matches our desiered state.**

Continue from Part 3 Demo.