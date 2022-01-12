resource "null_resource" "kubespray_download" {
  provisioner "local-exec" {
    command = "git clone https://github.com/kubernetes-sigs/kubespray"
  }
  depends_on = [openstack_compute_instance_v2.master,openstack_compute_instance_v2.worker]
}

resource "null_resource" "download_requrements" {
  provisioner "local-exec" {
    command = "cd kubespray && sudo apt install python3 -y && sudo apt install python3-pip -y && sudo pip3 install -r requirements.txt"
  }
  depends_on = [null_resource.kubespray_download]
}

resource "null_resource" "copy_sample" {
  provisioner "local-exec" {
    command = "cp -rfp kubespray/inventory/sample kubespray/inventory/mycluster"
  }
  depends_on = [null_resource.download_requrements]
}


resource "null_resource" "run_kubespray" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i host.ini -b kubespray/cluster.yml"
  }
  depends_on = [null_resource.copy_sample]
}

