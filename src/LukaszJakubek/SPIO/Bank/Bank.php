<?php
/**
 * Definicja klasy Bank
 */

namespace LukaszJakubek\SPIO\Bank;

use LukaszJakubek\SPIO\Bank\Transakcja\TransakcjaInterface;
use LukaszJakubek\SPIO\Bank\Rachunek\Rachunek;
use LukaszJakubek\SPIO\Bank\Rachunek\RachunekDebetowy;

/**
 * Podstawowa klasa sterująca całym bankiem
 */
class Bank
{
    /**
     * Tablica obiektów implementujących RachunekInterface indeksowana numerem rachunku
     *
     * @var array
     */
    private $rachunki = [];

    /**
     * Zakładanie rachunku. Rachunek zostanie stworzony i zapamiętany przez bank.
     *
     * @param string $numer
     * @param string $imie
     * @param string $nazwisko
     * @return Rachunek
     */
    public function zalozRachunek($numer, $imie, $nazwisko)
    {
        $rach = new Rachunek($numer, $imie, $nazwisko);
        $this->rachunki[$numer] = $rach;

        return $rach;
    }

    /**
     * Aktywuje funkcje debetowe w rachunku
     *
     * @param Rachunek $rachunek Rachunek
     * @param int $dopuszczalnyDebet Maksymalny debet
     * @return RachunekDebetowy
     */
    public function aktywujDebet(Rachunek $rachunek, $dopuszczalnyDebet)
    {
        $rach = new RachunekDebetowy($rachunek, $dopuszczalnyDebet);
        $this->rachunki[$rachunek->getNumer()] = $rach;

        return $rach;
    }

    /**
     * Wyszukiwanie rachunku po numerze
     *
     * Zwraca obiekt Rachunek jeżeli zostanie znaleziony lub null.
     *
     * @param string $numer
     * @return Rachunek|null
     */
    public function szukaj($numer)
    {
        return key_exists($numer, $this->rachunki) ? $this->rachunki[$numer] : null;
    }

    /**
     * Wykonaj transakcję
     *
     * @param TransakcjaInterface $transakcja
     */
    public function wykonajTransakcje(TransakcjaInterface $transakcja)
    {
        $transakcja->execute();
    }
}
