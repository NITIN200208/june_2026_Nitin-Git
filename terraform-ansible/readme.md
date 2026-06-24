full workflow end-to-end (Terraform → AWS → Ansible → Apache)
--------------------------------------------------------------

1. Local Machine (VS Code / Laptop)

You start here.

You have:

Terraform code
Ansible playbooks
PEM key (linux-first.pem)

You run:

terraform init
terraform apply
☁️ 2. Terraform creates AWS infrastructure

Terraform creates:

✅ 3 EC2 instances

Example:

Target1
Target2
Target3
✅ 1 Security Group

It must allow:

SSH (22)
⚠️ VERY IMPORTANT (common mistake)

Terraform must ensure:

✔ EC2 has PUBLIC IP
✔ Security group allows SSH
✔ Same key pair attached to all EC2

🖥️ 3. You choose 1 EC2 as Ansible Master

You SSH into it:

ssh -i linux-first.pem ec2-user@<master-public-ip>

Now this machine becomes:

👉 Ansible Control Node

🔐 4. You copy key to Ansible Master

From your laptop:

scp -i linux-first.pem linux-first.pem ec2-user@<master-ip>:~

On master:

chmod 400 linux-first.pem

👉 This fixes your earlier error

📦 5. Install Ansible on Master
sudo yum install -y ansible   # Amazon Linux 2

Check:

ansible --version
🧾 6. Create Inventory file (hosts.ini)

On master:

[webservers]
13.x.x.x
13.x.x.x
13.x.x.x

[webservers:vars]
ansible_user=ec2-user
ansible_ssh_private_key_file=/home/ec2-user/linux-first.pem
ansible_ssh_common_args='-o StrictHostKeyChecking=no'

👉 This tells Ansible:

where targets are
how to login
which key to use
🔎 7. Test inventory
ansible-inventory -i hosts.ini --graph

You confirmed:

✔ webservers group exists
✔ all 3 EC2 listed

⚡ 8. Test SSH via Ansible
ansible -i hosts.ini webservers -m ping
What happens internally:

Ansible does:

Master → SSH → Target1
Master → SSH → Target2
Master → SSH → Target3
❌ My error journey (what went wrong)

I faced these issues:

1. Inventory mismatch
servers vs webservers
2. Missing PEM file
linux-first.pem not found
3. Permission issue (final real blocker)
0664 too open → SSH rejected key

✔ fixed by:

chmod 400 linux-first.pem
🚀 9. Run playbook (Apache install)
- name: Install Apache
  hosts: webservers
  become: yes

  tasks:
    - name: Install httpd
      yum:
        name: httpd
        state: present

    - name: Start service
      service:
        name: httpd
        state: started
        enabled: yes

Run:

ansible-playbook -i hosts.ini install_apache.yml
🧠 FINAL FLOW (complete architecture)
Laptop
  │
  ▼
Terraform
  │
  ▼
AWS creates:
  - 3 EC2 (targets)
  - 1 EC2 (master)
  │
  ▼
Ansible Master
  │
  ├── hosts.ini (IP list)
  ├── linux-first.pem (SSH key)
  │
  ▼
SSH connection
  │
  ├── Target1
  ├── Target2
  └── Target3
  │
  ▼
Apache installed everywhere
🎯 Key lessons you learned
1. Terraform = infrastructure creation
2. Ansible = configuration management
3. SSH key permissions MUST be strict (400)
4. Inventory name must match command
5. AWS Security Group controls everything