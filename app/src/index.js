import Web3 from "web3";


const App = {
  web3: null,
  account: null,
  meta: null,

  start: async function() {
    try {
      // Se comprueba si Metamask está instalado
      if (window.ethereum) {
        // Se usa el proveedor de Metamask
        this.web3 = new Web3(window.ethereum);
        // Se solicita al usuario permiso para acceder a la billetera
        await window.ethereum.enable();
      } else if (window.web3) {
        // Si Metamask no está instalado, pero hay un proveedor de web3 disponible, se usa este
        this.web3 = new Web3(window.web3.currentProvider);
      } else {
        // Si no hay proveedores de web3 disponibles, se muestra un mensaje de error
        throw new Error("No se ha encontrado un proveedor de web3.");
      }

      // Se obtiene la dirección de la cuenta
      const accounts = await this.web3.eth.getAccounts();
      this.account = accounts[0];
      console.log("Dirección de la cuenta:", this.account);
    } catch (error) {
      console.error("Error al conectarse a la billetera:", error);
    }
  },
};

window.addEventListener("load", function() {
  const btnEmpezar = document.getElementById("btn-billetera");

  btnEmpezar.addEventListener("click", async function() {
    // Se inicia la conexión con Metamask al hacer clic en el botón "Empezar"
    await App.start();
  });
});
